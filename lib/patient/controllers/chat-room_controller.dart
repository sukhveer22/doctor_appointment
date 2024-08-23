import 'dart:io';
import 'package:doctor_appointment/models/chat_model.dart';
import 'package:doctor_appointment/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ChatController extends GetxController {
  ChatController({
    required this.chatroom,
    required this.targetUserId,
  });

  final String targetUserId;
  final ChatRoomModel chatroom;
  User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<QueryDocumentSnapshot> messages = <QueryDocumentSnapshot>[].obs;
  final messageController = TextEditingController();
  var isTyping = false.obs;
  var targetUserTyping = false.obs;
  RxString targetUserImage = "".obs;
  RxString targetUserName = "".obs;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();



  @override
  void onInit() {
    super.onInit();
    _listenToMessages();
    monitorTyping();
    fetchTargetUserData(targetUserId); // Fetch user data when initialized
  }
  Future<void> sendImage() async {
    try {
      // Pick an image from the gallery
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        Get.snackbar("Error", "No image selected",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      File imageFile = File(pickedFile.path);
      String fileName = Uuid().v1() + '.' + imageFile.path.split('.').last;

      // Upload image to Firebase Storage
      Reference storageRef =
      _storage.ref().child('chat_images').child(fileName);
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Send image message
      MessageModel newMessage = MessageModel(
        messageid: Uuid().v1(),
        sender: currentUser?.uid,
        createdon: DateTime.now(),
        text: '',
        imageUrl: imageUrl,
        seen: false,
      );

      await _firestore
          .collection("chatRooms")
          .doc(chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      chatroom.lastMessage =
      'Image'; // Optionally update chat room's last message
      await _firestore
          .collection("chatRooms")
          .doc(chatroom.chatroomid)
          .set(chatroom.toMap());

      Get.snackbar("Success", "Image sent successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to send image: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  Future<void> clearChat() async {
    try {
      // Reference to the chat room messages collection
      final messagesRef = _firestore
          .collection('chatRooms')
          .doc(chatroom.chatroomid)
          .collection('messages');

      final snapshot = await messagesRef.get();

      if (snapshot.docs.isNotEmpty) {
        final batch = _firestore.batch();
        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();

        chatroom.lastMessage = '';
        await _firestore
            .collection('chatRooms')
            .doc(chatroom.chatroomid)
            .set(chatroom.toMap());

        Get.snackbar("Success", "Chat cleared successfully",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Info", "No messages to clear",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to clear chat: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> downloadFile(String imageUrl, String fileName) async {
    try {
      final dio = Dio();

      final directory = await getTemporaryDirectory();

      final filePath = '${directory.path}/$fileName';

      await dio.download(imageUrl, filePath);

      print('File downloaded to: $filePath');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<void> fetchTargetUserData(String targetUserId) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('Users').doc(targetUserId).get();
      targetUserImage.value = doc["profilePictureUrl"];
      targetUserName.value = doc["name"];
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _listenToMessages() {
    _firestore
        .collection('chatRooms')
        .doc(chatroom.chatroomid)
        .collection('messages')
        .orderBy('createdon')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        messages.value = snapshot.docs;
      }
    }).onError((error) {
      Get.snackbar("Error", "Failed to load messages: $error",
          snackPosition: SnackPosition.BOTTOM);
    });
  }


   sendMessage(String text) async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg.isNotEmpty) {
      MessageModel newMessage = MessageModel(
        messageid: Uuid().v1(),
        sender: currentUser?.uid ?? "",
        createdon: DateTime.now(),
        text: msg,
        seen: false,
      );

      try {
        await _firestore
            .collection("chatRooms")
            .doc(chatroom.chatroomid)
            .collection("messages")
            .doc(newMessage.messageid)
            .set(text as Map<String, dynamic>);

        chatroom.lastMessage = msg;
        await _firestore
            .collection("chatRooms")
            .doc(chatroom.chatroomid)
            .set(chatroom.toMap());

        print("Message Sent!");
      } catch (e) {
        Get.snackbar("Error", "Failed to send message: $e",
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }


  void monitorTyping() {
    _firestore
        .collection("chatRooms")
        .doc(chatroom.chatroomid)
        .collection("typing")
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        if (doc.id == currentUser?.uid) {
          isTyping.value = doc.data()['isTyping'] ?? false;
        } else if (doc.id == targetUserId) {
          targetUserTyping.value = doc.data()['isTyping'] ?? false;
        }
      }
    }).onError((error) {
      Get.snackbar("Error", "Failed to monitor typing: $error",
          snackPosition: SnackPosition.BOTTOM);
    });
  }

  // Update typing status
  void updateTypingStatus(bool typing) {
    _firestore
        .collection("chatRooms")
        .doc(chatroom.chatroomid)
        .collection("typing")
        .doc(currentUser?.uid.toString())
        .set({'isTyping': typing}).catchError((error) {
      Get.snackbar("Error", "Failed to update typing status: $error",
          snackPosition: SnackPosition.BOTTOM);
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
