import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorScheduleController extends GetxController {
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var selectedStartTime = Rxn<TimeOfDay>();
  var selectedEndTime = Rxn<TimeOfDay>();

  void setStartDate(DateTime date) {
    startDate.value = date;
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  void setStartTime(TimeOfDay? time) {
    selectedStartTime.value = time;
  }

  void setEndTime(TimeOfDay? time) {
    selectedEndTime.value = time;
  }

  Future<void> saveToFirebase(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(userId.toString())
          .set({
        'startDate': startDate.value,
        'endDate': endDate.value,
        'startTime': selectedStartTime.value?.format(context),
        'endTime': selectedEndTime.value?.format(context),
      });
      Get.snackbar(
        'Success',
        'Data saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save data',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
