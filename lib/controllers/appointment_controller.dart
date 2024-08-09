import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/models/appointent_model.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  var selectedDate = DateTime.now().obs;

  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  String generateAppointmentId() {
    return FirebaseFirestore.instance.collection('appointments').doc().id;
  }

  Future<void> saveAppointmentToFirestore(AppointmentModel appointment) async {
    final appointmentRef = FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointment.id);
    await appointmentRef.set(appointment.toMap());
  }
}
