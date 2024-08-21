import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/models/chat_model.dart';
import 'package:doctor_appointment/models/message_model.dart';
import 'package:doctor_appointment/models/user_model.dart';
import 'package:doctor_appointment/patient/controllers/chat-room_controller.dart';
import 'package:doctor_appointment/util/app_color.dart';
import 'package:doctor_appointment/util/chat_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoomModel chatroom;
  final String doctorid;

  ChatScreen({Key? key, required this.chatroom, required this.doctorid}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late DocumentSnapshot userDoc;
  late final ChatRoomController controller;
  UserModel? targetUser; // Declare targetUser to store the fetched data

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatRoomController(
      chatroom: widget.chatroom,
      Doctorid: widget.doctorid,
    ));
    fetchDoctorData();
  }

  Future<void> fetchDoctorData() async {
    try {
      userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.chatroom.participants?.keys
          .firstWhere((id) => id != FirebaseAuth.instance.currentUser!.uid))
          .get();
      if (userDoc.exists) {
        setState(() {
          targetUser = UserModel.fromDocument(userDoc);
        });
      } else {
        print("Doctor data not found.");
      }
    } catch (e) {
      print("Error fetching doctor data: $e");
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        await controller.sendImage(image.path); // Pass the image path to the sendImage method
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Obx(
              () => Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(
                  targetUser?.profilePicture ??
                      'https://firebasestorage.googleapis.com/v0/b/task-5d3a8.appspot.com/o/profilepictures%2FWbDCkza2u8doplOz2mhuQk1nT9h2?alt=media&token=458251cb-126f-4f7f-9d4c-b4845346c2e3',
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(targetUser?.name ?? 'No Name'),
                  if (controller.targetUserTyping.value)
                    const Text(
                      "typing...",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((_) {
                Get.offAllNamed('/login');
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.messages.isEmpty) {
                  return const Center(child: Text("Say hi to your new friend"));
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          reverse: true,
                          itemCount: controller.messages.length,
                          itemBuilder: (context, index) {
                            MessageModel message = controller.messages[index];
                            return ChatBubble(message: message);
                          },
                        ),
                      ),
                      if (controller.isTyping.value)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Typing...  ",
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ).paddingOnly(bottom: 20);
                }
              }),
            ),
            Container(
              height: 60.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.r),
                  topLeft: Radius.circular(12.r),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.perm_media,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: controller.messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Enter message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                        ),
                        onChanged: (text) {
                          controller.updateTypingStatus(text.isNotEmpty);
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.sendMessage(controller.messageController.text); // Use the message text
                      controller.messageController.clear();
                      controller.updateTypingStatus(false);
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.send,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
