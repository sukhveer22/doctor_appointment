import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessages(String doctorId) {
    return _firestore
        .collection('appointments')
        .doc(doctorId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String doctorId, String message) async {
    if (message.trim().isEmpty) return;

    final User? user = auth.currentUser;

    if (user != null) {
      await _firestore
          .collection('appointments')
          .doc(doctorId)
          .collection('messages')
          .add(
        {
          'senderId': user.uid,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
        },
      );
    }
  }
}
