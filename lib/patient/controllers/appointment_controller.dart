import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/models/appointent_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  var selectedDate = DateTime.now().obs;

  // final User? firebaseuser =FirebaseAuth.instance.
  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  String generateAppointmentId() {
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
}
