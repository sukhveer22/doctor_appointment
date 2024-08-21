import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:doctor_appointment/patient/controllers/appointment_controller.dart';
import 'package:doctor_appointment/util/appTextStyle.dart';
import 'package:doctor_appointment/util/app_color.dart';
import 'package:doctor_appointment/util/app_config.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class AppointmentScreen extends StatelessWidget {
  final String doctorId;
  final AppointmentController controller = Get.put(AppointmentController());

  AppointmentScreen({super.key, required this.doctorId}) {
    controller.fetchDoctorData(doctorId: doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.hasError.value) {
              return Center(child: Text(controller.errorMessage.value));
            }

            var doctorData = controller.doctorData.value;
            String profilePictureUrl = doctorData["profilePictureUrl"] ?? '';
            String name = doctorData["name"] ?? 'No Name';
            String startDateStr = doctorData["startDate"] ?? '';
            String endDateStr = doctorData["endDate"]
                    .toString()
                    .replaceRange(0, 3, "")
                    .replaceRange(2, 7, "") ??
                '';
            String ssDateStr = doctorData["startDate"]
                    .toString()
                    .replaceRange(0, 3, "")
                    .replaceRange(2, 7, "") ??
                '';
            String specialty = doctorData["specialty"] ?? 'No specialty';
            String categoryId = doctorData["categoryId"]
                    ?.toString()
                    .replaceAll("Category.", "") ??
                'No Category';
            int enddate = int.parse(endDateStr);
            int ssdate = int.parse(ssDateStr);
            int dates = 0;
            for (int a = enddate; a < ssdate; a++) {
              dates = dates + 1;
            }


            DateTime startDate;
            DateTime endDate;

            try {
              startDate = DateTime.parse(startDateStr);
              endDate = DateTime.parse(endDateStr);
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
                  colors: [AppColors.primaryColor, Colors.white],
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
                        width: 200,
                         height: 200,
                        profilePictureUrl,
                        fit: BoxFit.cover,
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
                      decoration: BoxDecoration(
                        boxShadow: [
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
                            SizedBox(height: 60),
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
                              padding: EdgeInsets.all(10),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    endDate.difference(startDate).inDays + 1,
                                itemBuilder: (context, index) {
                                  DateTime date =
                                      startDate.add(Duration(days: index));
                                  return DateCapsule(
                                    date: date,
                                    isSelected: true,
                                    onTap: () {},
                                  );
                                },
                              ),
                            ),
                            Text(
                              "Select Time:",
                              style: AppTextStyles.header,
                            ),
                            Container(
                              height: 80,
                              width: AppConfig.screenWidth,
                              padding: EdgeInsets.all(10),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return TimeCapsule(
                                    time: index,
                                    isSelected: true,
                                    onTap: () {},
                                  );
                                },
                              ),
                            ),
                          ],
                        ).paddingAll(20),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
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

class DateCapsule extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback? onTap;

  DateCapsule({
    super.key,
    required this.date,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 124.w,
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffFF6D60) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4.0,
                spreadRadius: 1.0,
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              EasyDateFormatter.shortMonthName(date, "en_US"),
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? Colors.white : Color(0xff6D5D6E),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Color(0xff393646),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              EasyDateFormatter.shortDayName(date, "en_US"),
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? Colors.white : Color(0xff6D5D6E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeCapsule extends StatelessWidget {
  final int time;
  final VoidCallback? onTap;
  final bool isSelected;

  TimeCapsule({
    super.key,
    required this.time,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 124.w,
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffFF6D60) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4.0,
                spreadRadius: 1.0,
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time.toString(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Color(0xff393646),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
