import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;

    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("Users").doc(uid).get();

    if (docSnap.data() != null) {
      userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return userModel;
  }
}
