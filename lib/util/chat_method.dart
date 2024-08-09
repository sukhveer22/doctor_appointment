import 'package:doctor_appointment/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatefulWidget {
  final MessageModel message;
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

   ChatBubble({
    Key? key,
    required this.message,

  }) : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = widget.message.sender == widget.firebaseUser?.uid.toString();
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                widget.message.text.toString(),
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.black,
                ),
              ),
            ),
            // const SizedBox(height: 5.0),
            // Text(
            //   DateFormat('hh:mm a').format(message.timestamp.toDate()),
            //   style: TextStyle(
            //     color: isCurrentUser ? Colors.white70 : Colors.black54,
            //     fontSize: 10.0,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
