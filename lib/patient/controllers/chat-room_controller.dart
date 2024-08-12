import 'dart:io';
import 'package:doctor_appointment/models/chat_model.dart';
import 'package:doctor_appointment/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ChatRoomController extends GetxController {
  final ChatRoomModel chatroom;
  final String Doctorid;

  final User? firebaseUser = FirebaseAuth.instance.currentUser;
  RxBool seen = false.obs;

  var messages = <MessageModel>[].obs;
  final messageController = TextEditingController();
  var isTyping = false.obs;
  var targetUserTyping = false.obs;

  ChatRoomController({required this.chatroom, required this.Doctorid});

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
    monitorTyping(Doctorid);
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

  void sendMessage(String Doctorid) async {
    if (firebaseUser == null) return;

    if (Doctorid != firebaseUser!.uid) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseUser!.uid)
          .set({'active': true, "seen": true}, SetOptions(merge: true))
          .then((_) {
        print('User status updated');
      }).catchError((error) {
        print('Failed to update user status: $error');
      });
    }

    String msg = messageController.text.trim();
    messageController.clear();

    if (msg.isNotEmpty) {
      MessageModel newMessage = MessageModel(
        messageid: Uuid().v1(),
        sender: firebaseUser!.uid,
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

  void monitorTyping(String Doctorid) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatroom.chatroomid)
        .collection("typing")
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        if (doc.id == firebaseUser?.uid) {
          isTyping.value = doc.data()['isTyping'] ?? false;
        } else if (doc.id == Doctorid) {
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
        .doc(firebaseUser!.uid)
        .set({'isTyping': typing});
  }
  Future<void> sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);

    try {
      String fileName = Uuid().v1();
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child("chat_images")
          .child(fileName);

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      MessageModel imageMessage = MessageModel(
        messageid: Uuid().v1(),
        sender: firebaseUser!.uid,
        createdon: DateTime.now(),
        text: "[Image]",  // You can put a placeholder text here
        imageUrl: downloadUrl,  // Store the image URL here
        seen: false,
      );

      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(chatroom.chatroomid)
          .collection("messages")
          .doc(imageMessage.messageid)
          .set(imageMessage.toMap());

      chatroom.lastMessage = "[Image]";
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(chatroom.chatroomid)
          .set(chatroom.toMap());

      print("Image Sent!");
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }


  Future<File?> downloadImage(String imageUrl) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = path.join(appDocDir.path, path.basename(imageUrl));

      File downloadToFile = File(filePath);
      await FirebaseStorage.instance.refFromURL(imageUrl).writeToFile(downloadToFile);

      return downloadToFile;
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }

  void viewImageFullScreen(String imageUrl) {
    Get.to(() => FullScreenImageView(imageUrl: imageUrl));
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  FullScreenImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
