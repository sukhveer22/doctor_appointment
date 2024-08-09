import 'package:doctor_appointment/screens/appointment_screen.dart';
import 'package:doctor_appointment/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app_color.dart';

class CustomCard extends StatelessWidget {
  final Doctor doctor;

  CustomCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.r),
                  ),
                ),
                child: Image(image: AssetImage(doctor.imagePath)),
              ),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.star_lefthalf_fill,
                    size: 20,
                    color: Colors.green,
                  ),
                  Text(
                    doctor.rating.toString(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                doctor.title,
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 18,
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: Text(
                  doctor.description,
                  style: TextStyle(
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AppointmentScreen(
                          name: doctor.title,
                          destion: doctor.description,
                          imagePath: doctor.imagePath,
                          appointmentId: '',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Appointment',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 15),
    );
  }
}

class CustomRowContent extends StatelessWidget {
  final List<String> imagePaths;
  final List<String> texts;

  CustomRowContent({required this.imagePaths, required this.texts});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(texts.length, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              children: [
                Container(
                  width: 60.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage(imagePaths[index]),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                  height: 8,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 18,
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: Text(
                    texts[index],
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
