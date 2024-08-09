class UserModel {
  String? id;
  String? name;
  String? email;
  String? profilePicture;

  UserModel({this.id, this.name, this.email, this.profilePicture});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
    };
  }

  UserModel.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        email = json["email"],
        profilePicture = json['profilePicture'];
}
