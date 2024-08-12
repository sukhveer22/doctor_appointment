import 'package:doctor_appointment/models/doctor_model.dart';
import 'package:doctor_appointment/models/user_model.dart';
import 'package:doctor_appointment/patient/controllers/sign_controller.dart';
import 'package:doctor_appointment/patient/screens/login_screen.dart';
import 'package:doctor_appointment/util/app_color.dart';
import 'package:doctor_appointment/util/custom_text_field.dart';
import 'package:doctor_appointment/util/doctor_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  SignUpController signUpController = Get.put(SignUpController());
  UserModel userModel = UserModel();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) async {
      userModel =
          await signUpController.getUserFromPreferences() ?? UserModel();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.white,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 280.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(18.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        return GestureDetector(
                          child: const Icon(
                            CupertinoIcons.decrease_indent,
                            color: Colors.white,
                          ),
                        );
                      }),
                      const Icon(
                        CupertinoIcons.person_alt,
                        color: Colors.white,
                      )
                    ],
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Let's find",
                    style: TextStyle(
                      fontSize: 35.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "your top doctor!",
                    style: TextStyle(
                      fontSize: 35.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: CustomTextField(
                      prefixIcon: const Icon(CupertinoIcons.search),
                      controller: controller,
                      hintText: "Search health issue...",
                    ),
                  ),
                ],
              ).paddingAll(15),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Categories",
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ).paddingSymmetric(
              horizontal: 20,
            ),
          ),
        ],
      ),
    );
  }
}
