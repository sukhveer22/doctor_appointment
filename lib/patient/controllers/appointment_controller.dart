import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/models/appointent_model.dart';
import 'package:doctor_appointment/models/doctor_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var doctors = "".obs;
  var activeDoctors = "".obs;
  var nameDoctors = "".obs;
  var tapDoctors = "".obs;
  var numberDoctors = "".obs;
  var idDoctors = "".obs;
  var doctorData = {}.obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

   @override
  void onInit() {
    super.onInit();
    fetchDoctorData(); // Pass the doctorId here
  }

  void fetchDoctorData({String? doctorId}) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(doctorId)
          .get();
      if (doc.exists) {
        doctorData.value = doc.data()!;
        hasError.value = false;
      } else {
        hasError.value = true;
        errorMessage.value = "Doctor not found";
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error fetching doctor data: $e";
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  // final User? firebaseuser =FirebaseAuth.instance.
  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  String generatedoctorId() {
    return FirebaseFirestore.instance.collection('appointments').doc().id;
  }

  Future<void> saveAppointmentToFirestore(AppointmentModel appointment) async {
    try {
      final appointmentRef = FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointment.doctorName);
      await appointmentRef.set(appointment.toMap());

      Get.snackbar('Success', 'Appointment booked successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save appointment: $e',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<bool> isDateAvailable(DateTime selectedDate) async {
    try {
      final appointments =
          await FirebaseFirestore.instance.collection('appointments').get();

      for (var doc in appointments.docs) {
        final appointmentData = doc.data() as Map<String, dynamic>;
        dynamic appointmentDateValue = appointmentData['appointmentDate'];
        DateTime appointmentDate;

        if (appointmentDateValue is Timestamp) {
          appointmentDate = appointmentDateValue.toDate();
        } else if (appointmentDateValue is String) {
          try {
            appointmentDate = DateTime.parse(appointmentDateValue);
          } catch (e) {
            print('Error parsing date: $e');
            continue;
          }
        } else {
          print('Unexpected date type: ${appointmentDateValue.runtimeType}');
          continue;
        }

        if (DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
        ).isAtSameMomentAs(DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        ))) {
          return false;
        }
      }
    } catch (e) {
      print('Error checking date availability: $e');
    }
    return true;
  }

  void dataDoctors(String uid) async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data()!;

        activeDoctors.value = data['profilePictureUrl'] as String;
        nameDoctors.value = data['name'] as String;
        tapDoctors.value = data['categoryId'] as String;
        numberDoctors.value = data['phoneNumber'] as String;
        idDoctors.value = data['id'] as String;

        // Assuming Doctors has a fromMap method
        doctors.value = Doctors.fromDocumentSnapshot(snapshot) as String;
      } else {
        print('No data found for doctor with uid: $uid');
      }
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }
}
