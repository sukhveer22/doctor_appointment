class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  String? imageUrl;  // New field for image URL
  bool? seen;
  DateTime? createdon;

  MessageModel({
    this.messageid,
    this.sender,
    this.text,
    this.imageUrl,   // Include imageUrl in the constructor
    this.seen,
    this.createdon,
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    imageUrl = map["imageUrl"];   // Extract imageUrl from map
    seen = map["seen"];
    createdon = map["createdon"]?.toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "text": text,
      "imageUrl": imageUrl,  // Include imageUrl in the map
      "seen": seen,
      "createdon": createdon
    };
  }
}
