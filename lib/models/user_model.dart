import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? profilePicture;
  String? role;

  UserModel({this.id, this.name, this.email, this.profilePicture, this.role});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'role': role,
    };
  }

  UserModel.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        email = json["email"],
        profilePicture = json['profilePicture'],
        role = json['role'];
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      profilePicture: data['profilePicture'],
      role: data['role'],
    );
  }
}
