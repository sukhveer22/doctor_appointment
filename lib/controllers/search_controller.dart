import 'package:doctor_appointment/models/chat_model.dart';
import 'package:doctor_appointment/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class SearchsController extends GetxController {
  var searchResults = <UserModel>[].obs;
  var isLoading = true.obs;
  var searchQuery = 'doctor'.obs;
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, (_) => searchUsers(),
        time: const Duration(milliseconds: 300));
  }

  void searchUsers() async {
    isLoading.value = true;

    try {
      var query = FirebaseFirestore.instance
          .collection("Users")
          .where("name", isGreaterThanOrEqualTo: "doctor");

      if (firebaseUser?.displayName != null) {
        query = query.where("name", isNotEqualTo: firebaseUser?.displayName);
      }

      var snapshot = await query.get();

      searchResults.value = snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      if (searchResults.isEmpty) {
        Get.snackbar("No Results", "No users found matching your search.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<ChatRoomModel?> getChatroomModel() async {
    ChatRoomModel? chatRoom;
    String targetUser = "dAe5HGEmiGeUPB3Xjq1rSH85Rs73";
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("chatRoom")
          .where("participants.${firebaseUser?.uid}", isEqualTo: true)
          .where("participants.${targetUser}", isEqualTo: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var docData = snapshot.docs[0].data();
        chatRoom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      } else {
        var newChatroom = ChatRoomModel(
          chatroomid: Uuid().v1(),
          lastMessage: "",
          participants: {
            firebaseUser?.uid ?? "unknown": true,
            targetUser: true,
          },
        );

        await FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(newChatroom.chatroomid)
            .set(newChatroom.toMap());
        chatRoom = newChatroom;
        Get.log("New Chatroom Created!");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    return chatRoom;
  }
}
