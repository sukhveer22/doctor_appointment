import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';

class ChatBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isFromTargetUser;
  final Function(String) onImageTap;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isFromTargetUser,
    required this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Handling text messages
    if (message['text'] != null && message['text'].isNotEmpty) {
      return Align(
        alignment: isFromTargetUser ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isFromTargetUser ? Colors.blue : Colors.white, // Replace with AppColors if needed
            borderRadius: BorderRadius.only(
              topRight: isFromTargetUser ? Radius.circular(8.0) : Radius.zero,
              topLeft: isFromTargetUser ? Radius.zero : Radius.circular(8.0),
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
          child: Text(
            message['text'],
            style: TextStyle(
              color: isFromTargetUser ? Colors.white : Colors.black,
              fontSize: 18.0, // Use a fixed size
              fontWeight: FontWeight.w900,
            ),
          ).paddingSymmetric(horizontal: 10),
        ),
      );
    }
    // Handling image messages
    else if (message['imageUrl'] != null && message['imageUrl'].isNotEmpty) {
      return Align(
        alignment: isFromTargetUser ? Alignment.centerLeft : Alignment.centerRight,
        child: GestureDetector(
          onTap: () => onImageTap(message['imageUrl']),
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.symmetric(vertical: 10).copyWith(right: 15),
            decoration: BoxDecoration(
              color: isFromTargetUser ? Colors.grey[200] : Colors.white,
              borderRadius: BorderRadius.only(
                topRight: isFromTargetUser ? Radius.circular(20.0) : Radius.zero,
                topLeft: isFromTargetUser ? Radius.zero : Radius.circular(20.0),
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Image.network(
                message['imageUrl'],
                fit: BoxFit.cover,
                height: 200,
                width: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(Icons.error, color: Colors.red, size: 40),
                  );
                },
              ),
            ),
          ),
        ),
      );
    }
    // Empty container if neither text nor image is present
    else {
      return Container();
    }
  }
}
