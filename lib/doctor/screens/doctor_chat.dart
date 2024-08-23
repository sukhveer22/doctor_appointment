import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/models/chat_model.dart';
import 'package:doctor_appointment/patient/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ActiveUsersScreen extends StatefulWidget {
  @override
  _ActiveUsersScreenState createState() => _ActiveUsersScreenState();
}

class _ActiveUsersScreenState extends State<ActiveUsersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  final TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  Future<ChatRoomModel?> getChatRoomModel(String doctorId) async {
    final currentUserId = firebaseUser?.uid;

    if (currentUserId == null) {
      print("Current user ID is null");
      return null;
    }

    try {
      final chatroomSnapshot = await _firestore
          .collection('chatRoom')
          .where('participants.$currentUserId', isEqualTo: true)
          .where('participants.$doctorId', isEqualTo: true)
          .limit(1)
          .get();

      if (chatroomSnapshot.docs.isNotEmpty) {
        return ChatRoomModel.fromMap(
            chatroomSnapshot.docs.first.data());
      }

      final newChatRoom = ChatRoomModel(
        chatroomid: Uuid().v1(),
        participants: {
          currentUserId: true,
          doctorId: true,
        },
        lastMessage: '',
      );

      await _firestore
          .collection('chatRoom')
          .doc(newChatRoom.chatroomid)
          .set(newChatRoom.toMap());

      return newChatRoom;
    } catch (e) {
      print('Error getting or creating chat room: $e');
      return null;
    }
  }

  Future<void> _updateUserStatus(String userId) async {
    try {
      await _firestore.collection('Users').doc(userId).update({"seen": false});
    } catch (e) {
      print('Failed to update user status: $e');
      Get.snackbar(
        'Error',
        'Failed to update user status.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Users', style: titleStyle),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('No active users found.', style: titleStyle));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var userDoc = snapshot.data!.docs[index];
              var userData = userDoc.data() as Map<String, dynamic>;
              var userId = userDoc.id;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(
                    userData['profilePicture'] ??
                        'https://via.placeholder.com/150',
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(userData['name'] ?? 'No Name', style: titleStyle),
                    userData['seen'] == true
                        ? Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    )
                        : Container(),
                  ],
                ),
                onTap: () async {
                  final chatroomModel = await getChatRoomModel(userId);
                  if (chatroomModel != null) {
                    Get.to(() => ChatRoomPage(
                      targetUserId: userId,
                      chatroom: chatroomModel,
                    ));
                    await _updateUserStatus(userId);
                  } else {
                    Get.snackbar(
                      'Error',
                      'Unable to create or fetch chatroom.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
