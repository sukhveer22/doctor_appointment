import 'package:doctor_appointment/controllers/appointment_controller.dart';
import 'package:doctor_appointment/controllers/search_controller.dart';
import 'package:doctor_appointment/controllers/sign_controller.dart';
import 'package:doctor_appointment/models/appointent_model.dart';
import 'package:doctor_appointment/models/user_model.dart';
import 'package:doctor_appointment/screens/chat_screen.dart';
import 'package:doctor_appointment/screens/doctor_chat.dart';
import 'package:doctor_appointment/util/app_color.dart';
import 'package:doctor_appointment/util/app_config.dart';
import 'package:doctor_appointment/util/path.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppointmentScreen extends StatefulWidget {
  final String? name;
  final String? destination;
  final String? imagePath;
  final String appointmentId;
  final String doctorId;

  const AppointmentScreen({
    super.key,
    this.name,
    this.destination,
    this.imagePath,
    required this.appointmentId,
    this.doctorId = "dAe5HGEmiGeUPB3Xjq1rSH85Rs73",
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final AppointmentController _controller = Get.put(AppointmentController());
  final SearchsController searchController = Get.put(SearchsController());
  final SignUpController signUpController = Get.put(SignUpController());
  UserModel? userModel;
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userModel =
          await signUpController.getUserFromPreferences() ?? UserModel();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Appointment",
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () async {
              if (widget.doctorId == firebaseUser?.uid.toString()) {
                Get.to(ActiveUsersScreen());
              } else {
                var chatroomModel = await searchController.getChatroomModel();
                if (chatroomModel != null) {
                  Get.to(() => ChatScreen(
                        chatroom: chatroomModel,
                      ));
                } else {
                  Get.snackbar("Error", "Chatroom could not be created.");
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.asset(widget.imagePath ?? ""),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  widget.name ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10.h,
                      child: const Image(image: AssetImage(Assets.con1)),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "Cardio Specialist",
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: AppConfig.screenWidth,
                height: 120.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  color: AppColors.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard("350+", "Patients", AppColors.primaryColor),
                    _buildStatCard("35+", "Exp. years", Colors.greenAccent),
                    _buildStatCard("990+", "Reviews", Colors.redAccent),
                  ],
                ).paddingSymmetric(horizontal: 6.w),
              ),
              SizedBox(height: 20.h),
              Text(
                "About Doctor",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                widget.destination ?? "",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.sp),
              ),
              SizedBox(height: 20.h),
              Text(
                "Schedules",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25.sp,
                ),
              ),
              SizedBox(height: 10.h),
              EasyDateTimeLine(
                initialDate: DateTime.now(),
                onDateChange: (selectedDate) {
                  _controller.updateDate(selectedDate);
                },
                headerProps: const EasyHeaderProps(
                  monthPickerType: MonthPickerType.switcher,
                  dateFormatter: DateFormatter.fullDateDMY(),
                ),
                dayProps: EasyDayProps(
                  dayStructure: DayStructure.dayStrDayNum,
                  activeDayStyle: DayStyle(
                    borderRadius: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                child: SizedBox(
                  width: AppConfig.screenWidth,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (userModel != null) {
                        AppointmentModel appointment = AppointmentModel(
                          id: userModel!.id.toString(),
                          doctorName: widget.name ?? "Unknown Doctor",
                          doctorImage: widget.imagePath ?? "",
                          patientId: "",
                          appointmentDate: _controller.selectedDate.value,
                        );

                        await _controller
                            .saveAppointmentToFirestore(appointment);

                        Get.snackbar(
                          "Booking",
                          "Appointment booked successfully!",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        Get.snackbar("Error", "User data is not available");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      "Booking Appointment",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String stat, String label, Color color) {
    return Container(
      height: 90.h,
      width: 100.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat,
            style: TextStyle(
              color: color,
              fontSize: 40.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 15.sp),
          ),
        ],
      ),
    );
  }
}
