import 'package:doctor_appointment/models/doctor_model.dart';
import 'package:doctor_appointment/patient/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  var doctors = <Doctors>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  void fetchDoctors() async {
    try {
      var querySnapshot = await _firestore.collection('doctors').get();
      var doctorList = querySnapshot.docs.map((doc) => Doctors.fromDocument(doc.data())).toList();
      doctors.assignAll(doctorList);
    } catch (e) {
      print("Error fetching doctors: $e");
    }
  }
}
