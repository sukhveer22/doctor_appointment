import 'package:doctor_appointment/models/doctor_model.dart';
import 'package:doctor_appointment/patient/screens/appointment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app_color.dart';

class CustomCard extends StatelessWidget {
  final Doctors doctor;
  final User? firebaseuser = FirebaseAuth.instance.currentUser;

  CustomCard({
    super.key,
    required this.doctor,
  });

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
                child: Image(
                    image: NetworkImage(doctor.profilePictureUrl.toString())),
              ),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.star_lefthalf_fill,
                    size: 20,
                    color: Colors.green,
                  ),
                  Text(
                    "55.0",
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
                doctor.phoneNumber.toString(),
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
                  doctor.specialty,
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
                            name: doctor.name,
                            destination: doctor.specialty,
                            imagePath: doctor.profilePictureUrl,
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
