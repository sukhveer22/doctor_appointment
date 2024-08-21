import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DoctorScheduleController extends GetxController {
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var selectedStartTime = Rxn<TimeOfDay>();
  bool saveDataLoading = false;
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
    saveDataLoading= true;
    // Format dates and times
    final String formattedStartDate =
        DateFormat('MM-dd-yyyy').format(startDate.value);
    final String formattedEndDate =
        DateFormat('MM-dd-yyyy').format(endDate.value);
    final String? formattedStartTime = selectedStartTime.value?.format(context);
    final String? formattedEndTime = selectedEndTime.value?.format(context);

    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'startDate': formattedStartDate,
        'endDate': formattedEndDate,
        'startTime': formattedStartTime ?? '',
        'endTime': formattedEndTime ?? '',
      }, SetOptions(merge: true));
      Get.back();
      saveDataLoading= false;
      Get.snackbar(
        'Success',
        'Data saved successfully',
        snackPosition: SnackPosition.TOP,
      );
      Get.back();
      saveDataLoading= false;// Close the current screen after saving
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save data',
        snackPosition: SnackPosition.BOTTOM,
      );  saveDataLoading= false;
    }
  }
}
