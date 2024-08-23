// import 'package:doctor_appointment/models/chat_model.dart';
// import 'package:doctor_appointment/models/message_model.dart';
// import 'package:doctor_appointment/models/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:uuid/uuid.dart';
//
// class ChatController extends GetxController {
//   final UserModel targetUser;
//   final ChatRoomModel chatroom;
//   final UserModel userModel;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   ChatController({
//     required this.targetUser,
//     required this.chatroom,
//     required this.userModel,
//     required User firebaseUser,
//   });
//
//   RxList<QueryDocumentSnapshot> messages = <QueryDocumentSnapshot>[].obs;
//   final messageController = TextEditingController();
//   var isTyping = false.obs; // Typing status for the current user
//   var targetUserTyping = false.obs; // Typing status for the target user
//
//   @override
//   void onInit() {
//     super.onInit();
//     _listenToMessages();
//     monitorTyping();
//   }
//
//   // Listen to messages in the chatroom
//   void _listenToMessages() {
//     _firestore
//         .collection('chatRooms')
//         .doc(chatroom.chatroomid)
//         .collection('messages')
//         .orderBy('createdon')
//         .snapshots()
//         .listen((snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         messages.value = snapshot.docs;
//       }
//     }).onError((error) {
//       Get.snackbar("Error", "Failed to load messages: $error",
//           snackPosition: SnackPosition.BOTTOM);
//     });
//   }
//
//   // Send a new message
//   void sendMessage() async {
//     String msg = messageController.text.trim();
//     messageController.clear();
//
//     if (msg.isNotEmpty) {
//       MessageModel newMessage = MessageModel(
//         messageid: Uuid().v1(),
//         sender: userModel.id,
//         createdon: DateTime.now(),
//         text: msg,
//         seen: false,
//       );
//
//       try {
//         await _firestore
//             .collection("chatRooms")
//             .doc(chatroom.chatroomid)
//             .collection("messages")
//             .doc(newMessage.messageid)
//             .set(newMessage.toMap());
//
//         chatroom.lastMessage = msg;
//         await _firestore
//             .collection("chatRooms")
//             .doc(chatroom.chatroomid)
//             .set(chatroom.toMap());
//
//         print("Message Sent!");
//       } catch (e) {
//         Get.snackbar("Error", "Failed to send message: $e",
//             snackPosition: SnackPosition.BOTTOM);
//       }
//     }
//   }
//
//   // Monitor typing status for both users
//   void monitorTyping() {
//     _firestore
//         .collection("chatRooms")
//         .doc(chatroom.chatroomid)
//         .collection("typing")
//         .snapshots()
//         .listen((snapshot) {
//       for (var doc in snapshot.docs) {
//         if (doc.id == userModel.id) {
//           isTyping.value = doc.data()['isTyping'] ?? false;
//         } else if (doc.id == targetUser.id) {
//           targetUserTyping.value = doc.data()['isTyping'] ?? false;
//         }
//       }
//     }).onError((error) {
//       Get.snackbar("Error", "Failed to monitor typing: $error",
//           snackPosition: SnackPosition.BOTTOM);
//     });
//   }
//
//   // Update typing status in Firestore
//   void updateTypingStatus(bool typing) {
//     _firestore
//         .collection("chatRooms")
//         .doc(chatroom.chatroomid)
//         .collection("typing")
//         .doc(userModel.id)
//         .set({'isTyping': typing})
//         .catchError((error) {
//       Get.snackbar("Error", "Failed to update typing status: $error",
//           snackPosition: SnackPosition.BOTTOM);
//     });
//   }
//
//   @override
//   void onClose() {
//     messageController.dispose();
//     super.onClose();
//   }
// }
