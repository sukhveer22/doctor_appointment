import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/controllers/chat-room_controller.dart';
import 'package:doctor_appointment/models/chat_model.dart';
import 'package:doctor_appointment/models/message_model.dart';
import 'package:doctor_appointment/models/user_model.dart';
import 'package:doctor_appointment/util/chat_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoomModel chatroom;

  ChatScreen({
    super.key,
    required this.chatroom,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late UserModel targetUser;
  late DocumentSnapshot userDoc;
  late final ChatRoomController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatRoomController(chatroom: widget.chatroom));
    fetchDoctorData(); // Assuming you're fetching doctor data here
  }

  Future<void> fetchDoctorData() async {
    try {
      userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.chatroom.participants?.keys
              .firstWhere((id) => id != FirebaseAuth.instance.currentUser!.uid))
          .get();
      setState(() {
        targetUser = UserModel.fromDocument(userDoc);
      });
    } catch (e) {
      print("Error fetching doctor data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(
                  targetUser.profilePicture ??
                      'https://firebasestorage.googleapis.com/v0/b/task-5d3a8.appspot.com/o/profilepictures%2FWbDCkza2u8doplOz2mhuQk1nT9h2?alt=media&token=458251cb-126f-4f7f-9d4c-b4845346c2e3',
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(targetUser.name ?? 'No Name'),
                  if (controller.targetUserTyping.value)
                    const Text(
                      "typing...",
                      style: TextStyle(fontSize: 15),
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
      body: Container(
        decoration: const BoxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.messages.isEmpty) {
                    return const Center(
                        child: Text("Say hi to your new friend"));
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

                              return ChatBubble(
                                message: message,
                              );
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
                    );
                  }
                }),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Enter message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(14),
                            ),
                          ),
                        ),
                        onChanged: (text) {
                          controller.updateTypingStatus(text.isNotEmpty);
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.sendMessage();
                        controller.updateTypingStatus(false);
                      },
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
