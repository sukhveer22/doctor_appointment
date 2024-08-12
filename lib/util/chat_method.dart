import 'package:doctor_appointment/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui';

import 'package:doctor_appointment/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

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
  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(Icons.error, color: Colors.red, size: 40.sp),
                    );
                  },
                ),
              ),
              Positioned(
                top: 40.h,
                right: 20.w,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30.sp),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Positioned(
                bottom: 40.h,
                right: 20.w,
                child: IconButton(
                  icon: Icon(Icons.download, color: Colors.white, size: 30.sp),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    _downloadImage(imageUrl);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _downloadImage(String imageUrl) async {
    final fileName = imageUrl.split('/').last;
    await downloadImage(imageUrl, fileName);
  }

  Future<void> downloadImage(String url, String fileName) async {
    if (await Permission.storage.request().isGranted) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';

        final response = await Dio().download(url, filePath);

        if (response.statusCode == 200) {
          print('File downloaded successfully');
        } else {
          print('Failed to download file');
        }
      } catch (e) {
        print('Error downloading file: $e');
      }
    } else {
      print('Permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser =
        widget.message.sender == widget.firebaseUser?.uid.toString();

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.r),
            bottomLeft: Radius.circular(20.r),
            topLeft: Radius.circular(15.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.message.imageUrl != null && widget.message.imageUrl!.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _showFullScreenImage(widget.message.imageUrl!);
                },
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      widget.message.imageUrl!,
                      fit: BoxFit.cover,
                      height: 200.h,
                      width: MediaQuery.of(context).size.width * 0.7,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.error, color: Colors.red, size: 40.sp),
                        );
                      },
                    ),
                  ),
                ),
              ),
            if (widget.message.text != null && widget.message.text!.isNotEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(
                  widget.message.text!,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: isCurrentUser ? Colors.white : Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}



Future<void> downloadImage(String url, String fileName) async {
  // Request storage permissions
  if (await Permission.storage.request().isGranted) {
    try {
      // Get the temporary directory of the app
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // Download the image
      final response = await Dio().download(url, filePath);

      if (response.statusCode == 200) {
        print('File downloaded successfully');
      } else {
        print('Failed to download file');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  } else {
    print('Permission denied');
  }
}
