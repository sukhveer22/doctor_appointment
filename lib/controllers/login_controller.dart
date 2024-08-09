import 'package:doctor_appointment/screens/dashborad/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isLoading = false.obs; // Track loading state

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    try {
      if (emailController.text.isEmpty) {
        Get.snackbar('Error', 'Email cannot be empty');
      } else if (passwordController.text.isEmpty) {
        Get.snackbar('Error', 'Password cannot be empty');
      } else {
        isLoading.value = true; // Start loading
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Get.to(DashboardScreen());
        Get.snackbar('Success', 'Logged in successfully');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
}
