import 'package:doctor_appointment/models/chat_model.dart';
import 'package:doctor_appointment/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class ChatRoomController extends GetxController {
  final ChatRoomModel chatroom;
  final String targetUser = "dAe5HGEmiGeUPB3Xjq1rSH85Rs73";
  final User? firebaseUser = FirebaseAuth.instance.currentUser;
  RxBool seen = false.obs;

  ChatRoomController({
    required this.chatroom,
  });

  var messages = <MessageModel>[].obs;
  final messageController = TextEditingController();
  var isTyping = false.obs;
  var targetUserTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
    monitorTyping();
  }

  void fetchMessages() {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatroom.chatroomid)
        .collection("messages")
        .orderBy("createdon", descending: true)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        messages.value = snapshot.docs
            .map((doc) =>
                MessageModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      }
    });
  }

  void sendMessage() async {
    if (firebaseUser == null) return;
    if ("dAe5HGEmiGeUPB3Xjq1rSH85Rs73" != firebaseUser?.uid.toString()) {
      if (firebaseUser != null) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(firebaseUser?.uid)
            .set({'active': true, "seen": true}, SetOptions(merge: true)).then(
                (_) {
          print('>>>>>>>>>>>>>>>>>>User status updated');
        }).catchError((error) {
          print('>>>>>>>>>>>>Failed to update user status: $error');
        });
      }
    }

    String msg = messageController.text.trim();
    messageController.clear();

    if (msg.isNotEmpty) {
      MessageModel newMessage = MessageModel(
        messageid: Uuid().v1(),
        sender: firebaseUser?.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false,
      );

      try {
        await FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(chatroom.chatroomid)
            .collection("messages")
            .doc(newMessage.messageid)
            .set(newMessage.toMap());

        chatroom.lastMessage = msg;
        await FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(chatroom.chatroomid)
            .set(chatroom.toMap());

        print("Message Sent!");
      } catch (e) {
        Get.snackbar("Error", e.toString(),
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void monitorTyping() {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatroom.chatroomid)
        .collection("typing")
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        if (doc.id == firebaseUser?.uid) {
          isTyping.value = doc.data()['isTyping'] ?? false;
        } else if (doc.id == targetUser) {
          targetUserTyping.value = doc.data()['isTyping'] ?? false;
        }
      }
    });
  }

  void updateTypingStatus(bool typing) {
    if (firebaseUser == null) return;

    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatroom.chatroomid)
        .collection("typing")
        .doc(firebaseUser?.uid)
        .set({'isTyping': typing});
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
