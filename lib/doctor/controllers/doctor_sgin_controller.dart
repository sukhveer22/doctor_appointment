import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/doctor/screens/dahsborad/doctor-dashborad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:doctor_appointment/models/doctor_model.dart';
import 'package:doctor_appointment/models/user_model.dart';

import '../screens/profile_screens/doctorprofile_screen.dart';

class DoctorSignController extends GetxController {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var categoryIdController = TextEditingController();
  var passwordController = TextEditingController();
  var specialtyController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;
  Rx<CroppedFile?> imageFile = Rx<CroppedFile?>(null);

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> signUp() async {
    if (_validateInputs()) {
      try {
        isLoading.value = true;

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        String? profilePictureUrl;
        if (imageFile.value != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profilePicture/${userCredential.user!.uid}');
          final uploadTask = storageRef.putFile(File(imageFile.value!.path));
          final snapshot = await uploadTask.whenComplete(() {});
          profilePictureUrl = await snapshot.ref.getDownloadURL();
        }

        await userCredential.user?.updatePhotoURL(profilePictureUrl);
        await userCredential.user
            ?.updateDisplayName(nameController.text.trim());

        final doctor = Doctors(
          id: userCredential.user!.uid,
          name: nameController.text.trim(),
          specialty: specialtyController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: phoneNumberController.text.trim(),
          profilePictureUrl: profilePictureUrl,
          categoryId: categoryIdController.text.trim(),
        );

        await saveDoctorToFirestore(doctor);
        await saveUserToPreferences(userCredential.user!.uid);

        Get.off(Doctordashborad());
        Get.snackbar('Success', 'Signed up successfully');
      } catch (e) {
        Get.snackbar('Error', _getErrorMessage(e));
      } finally {
        isLoading.value = false;
      }
    }
  }

  bool _validateInputs() {
    if (nameController.text.trim().isEmpty ||
        specialtyController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        categoryIdController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.');
      return false;
    }
    return true;
  }

  Timestamp _parseTimestamp(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return Timestamp.fromDate(dateTime);
    } catch (e) {
      Get.snackbar('Error', 'Invalid date format.');
      return Timestamp.now(); // Return current time as a fallback
    }
  }

  Future<void> saveDoctorToFirestore(Doctors doctor) async {
    try {
      final doctorRef =
          FirebaseFirestore.instance.collection('Doctors').doc(doctor.id);
      await doctorRef.set(doctor.toMap());
    } catch (e) {
      print('Error saving doctor to Firestore: $e');
    }
  }

  Future<void> saveUserToPreferences(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
    } catch (e) {
      print('Error saving user to SharedPreferences: $e');
    }
  }

  Future<UserModel?> getUserFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('userId');
      final name = prefs.getString('userName');
      final email = prefs.getString('userEmail');

      if (id != null && name != null && email != null) {
        return UserModel(id: id, name: name, email: email);
      }
      return null;
    } catch (e) {
      print('Error retrieving user from SharedPreferences: $e');
      return null;
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'This email is already in use.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'operation-not-allowed':
          return 'Operation not allowed. Please contact support.';
        case 'weak-password':
          return 'The password is too weak.';
        default:
          return 'An unknown error occurred. Please try again.';
      }
    }
    return 'An error occurred. Please try again.';
  }

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    try {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
      );

      if (croppedImage != null) {
        imageFile.value = croppedImage;
      }
    } catch (e) {
      Get.snackbar("Error", "Error cropping image: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void showPhotoOptions() {
    Get.dialog(
      AlertDialog(
        title: Text("Upload Profile Picture"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Get.back();
                selectImage(ImageSource.gallery);
              },
              leading: Icon(Icons.photo_album),
              title: Text("Select from Gallery"),
            ),
            ListTile(
              onTap: () {
                Get.back();
                selectImage(ImageSource.camera);
              },
              leading: Icon(Icons.camera_alt),
              title: Text("Select from Camera"),
            ),
          ],
        ),
      ),
    );
  }
}
