import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/models/chat_model.dart';
import 'package:doctor_appointment/patient/screens/chat_screen.dart';
import 'package:doctor_appointment/util/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:doctor_appointment/patient/controllers/appointment_controller.dart';
import 'package:doctor_appointment/util/appTextStyle.dart';
import 'package:doctor_appointment/util/app_color.dart';
import 'package:doctor_appointment/util/app_config.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:uuid/uuid.dart';

import '../../util/Date-time-show-class.dart';

class AppointmentScreen extends StatelessWidget {
  final String doctorId;
  late String selectedDates = "";
  String selectedTimes = "";
  User? firebaseuid = FirebaseAuth.instance.currentUser;

  AppointmentScreen({super.key, required this.doctorId});

  final AppointmentController controller = Get.put(AppointmentController());

  DateTime? _selectedDate;
  int? _selectedTime;

  Future<ChatRoomModel?> getChatRoomModel(String doctorId) async {
    final currentUserId = firebaseuid?.uid;

    if (currentUserId == null) {
      print("Current user ID is null");
      return null;
    }

    try {
      final chatroomSnapshot = await FirebaseFirestore.instance
          .collection('chatRoom')
          .where('participants.$currentUserId', isEqualTo: true)
          .where('participants.$doctorId', isEqualTo: true)
          .limit(1)
          .get();

      if (chatroomSnapshot.docs.isNotEmpty) {
        return ChatRoomModel.fromMap(
            chatroomSnapshot.docs.first.data() as Map<String, dynamic>);
      }

      final newChatRoom = ChatRoomModel(
        chatroomid: Uuid().v1(),
        participants: {
          currentUserId: true,
          doctorId: true,
        },
        lastMessage: '',
      );

      await FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(newChatRoom.chatroomid)
          .set(newChatRoom.toMap());

      return newChatRoom;
    } catch (e) {
      print('Error getting or creating chat room: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(doctorId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('Doctor not found'));
              }

              var doctorData = snapshot.data!.data() as Map<String, dynamic>;
              String profilePictureUrl = doctorData["profilePictureUrl"] ?? '';
              String name = doctorData["name"] ?? 'No Name';
              String startDateStr = doctorData["startDate"]
                      .toString()
                      .replaceRange(0, 3, "")
                      .replaceRange(2, 7, "") ??
                  '';
              String endDateStr = doctorData["endDate"]
                      .toString()
                      .replaceRange(0, 3, "")
                      .replaceRange(2, 7, "") ??
                  '';

              String specialty = doctorData["specialty"] ?? 'No specialty';
              String categoryId = doctorData["categoryId"]
                      ?.toString()
                      .replaceAll("Category.", "") ??
                  'No Category';
              int ssdate = int.parse(startDateStr);
              int enddate = int.parse(endDateStr);
              int dates = 0;
              if (ssdate == enddate) {
                dates = 1;
              } else {
                for (int a = ssdate; a < enddate; a++) {
                  dates = dates + 1;
                }
              }
              print(dates);
              DateTime startDate;
              DateTime endDate;
              String startTimeStr = doctorData["startTime"] ?? '';
              String endTimeStr = doctorData["endTime"] ?? '';

              List<int> sttimea = [];
              List<int> entimea = [];

              if (startTimeStr == endTimeStr) {
                String chp = startTimeStr[5];
                String chpm = startTimeStr[6];
                String cha = startTimeStr[5];
                String cham = startTimeStr[6];

                if (chp + chpm != cha + cham) {
                  for (int a = 1; a <= 12; a++) {
                    sttimea.add(a);
                    entimea.add(a);
                  }
                } else {
                  sttimea = [1];
                  entimea = [1];
                }
              } else if (startTimeStr.length == 7 && endTimeStr.length == 7) {
                int sttime = int.parse(startTimeStr.replaceRange(1, 7, ""));
                int entime = int.parse(endTimeStr.replaceRange(1, 7, ""));

                for (int a = sttime; a <= 12; a++) {
                  sttimea.add(a);
                }
                for (int a = entime; a <= 12; a++) {
                  entimea.add(a);
                }

                print(sttimea);
                print(entimea);
              } else if (startTimeStr.length == 8 && endTimeStr.length == 8) {
                int sttime = int.parse(startTimeStr.replaceRange(2, 8, ""));
                int entime = int.parse(endTimeStr.replaceRange(2, 8, ""));

                for (int a = sttime; a <= 12; a++) {
                  sttimea.add(a);
                }
                for (int a = entime; a <= 12; a++) {
                  entimea.add(a);
                }

                print(sttimea);
                print(entimea);
              } else if (startTimeStr.length == 7 && endTimeStr.length == 8) {
                int sttime = int.parse(startTimeStr.replaceRange(1, 7, ""));
                int entime = int.parse(endTimeStr.replaceRange(2, 8, ""));

                for (int a = sttime; a <= 12; a++) {
                  sttimea.add(a);
                }
                for (int a = entime; a <= 12; a++) {
                  entimea.add(a);
                }

                print(sttimea);
                print(entimea);
              } else if (startTimeStr.length == 8 && endTimeStr.length == 7) {
                int sttime = int.parse(startTimeStr.replaceRange(2, 8, ""));
                int entime = int.parse(endTimeStr.replaceRange(1, 7, ""));

                for (int a = sttime; a <= 12; a++) {
                  sttimea.add(a);
                }
                for (int a = entime; a <= 12; a++) {
                  entimea.add(a);
                }

                print(sttimea);
                print(entimea);
              } else {
                print(">>>>>>>>>>>>>>Error");
              }

              try {
                startDate = DateTime.parse(ssdate.toString());
                endDate = DateTime.parse(enddate.toString());
              } catch (e) {
                startDate = DateTime.now();
                endDate = startDate.add(Duration(days: dates));
              }

              return Container(
                height: AppConfig.screenHeight,
                width: AppConfig.screenWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    end: Alignment.topCenter,
                    colors: const [AppColors.primaryColor, Colors.white],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 60),
                    if (profilePictureUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Image.network(
                          profilePictureUrl,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, size: 100.w);
                          },
                        ),
                      )
                    else
                      Icon(Icons.account_circle, size: 100.w),
                    SizedBox(height: 10.h),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Category: ",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          categoryId,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        width: AppConfig.screenWidth,
                        padding: EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 5.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(35.r),
                            topLeft: Radius.circular(35.r),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(),
                              Text(
                                "Specialty:",
                                style: AppTextStyles.header,
                              ),
                              Text(
                                specialty,
                                style: AppTextStyles.body,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Divider(),
                              ),
                              Text(
                                "Select Date:",
                                style: AppTextStyles.header,
                              ),
                              Container(
                                height: 80,
                                width: AppConfig.screenWidth,
                                child: Center(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: dates,
                                    itemBuilder: (context, index) {
                                      DateTime date =
                                          startDate.add(Duration(days: index));
                                      return Center(
                                        child: DateCapsule(
                                          date: date,
                                          isSelected: true,
                                          dates: ssdate + index,
                                          onTap: () {
                                            selectedDates =
                                                "${EasyDateFormatter.shortMonthName(date, "en_US")} ${ssdate + index} ${EasyDateFormatter.shortDayName(date, "en_US")}";
                                          },
                                        ),
                                      ).paddingSymmetric(horizontal: 10);
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                "Select Time:",
                                style: AppTextStyles.header,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 60,
                                width: AppConfig.screenWidth,
                                child: Center(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: sttimea.length,
                                    itemBuilder: (context, index) {
                                      return TimeCapsule(
                                        time: sttimea[index],
                                        isSelected: true,
                                        onTap: () {
                                          selectedTimes = "${sttimea[index]}AM";
                                        },
                                        text: 'AM',
                                      ).paddingSymmetric(horizontal: 10);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 60,
                                width: AppConfig.screenWidth,
                                child: Center(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: entimea.length,
                                    itemBuilder: (context, index) {
                                      return TimeCapsule(
                                        time: entimea[index],
                                        isSelected: true,
                                        onTap: () {
                                          selectedTimes = "${entimea[index]}PM";
                                        },
                                        text: 'PM',
                                      ).paddingSymmetric(horizontal: 10);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                    width: 150.w,
                                    fontSize: 12.sp,
                                    text: "Send message",
                                    onPressed: ()  async {
                                      final chatroomModel = await getChatRoomModel(doctorId);

                                      if (chatroomModel != null) {
                                        Get.to(() => ChatRoomPage(
                                          targetUserId: doctorId,
                                          chatroom: chatroomModel,
                                        ));
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          'Unable to create or fetch chatroom.',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }
                                    },
                                  ),
                                  CustomButton(
                                    width: 150.w,
                                    text: "Book Appointment",
                                    fontSize: 12.sp,
                                    onPressed: () {
                                      if (selectedDates.isNotEmpty &&
                                          selectedTimes.isNotEmpty) {
                                        controller.saveAppointment(
                                          selectedDate: selectedDates,
                                          selectedTime: selectedTimes,
                                          doctoruid: doctorId,
                                          doctorImage: profilePictureUrl,
                                        );
                                      } else {
                                        Get.snackbar('Error',
                                            'Please select a date and time.',
                                            colorText: Colors.white,
                                            backgroundColor: Colors.red,
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ).paddingAll(20),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 30,
            left: 10,
            child: Center(
              child: IconButton(
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
