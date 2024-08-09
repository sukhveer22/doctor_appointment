import 'package:doctor_appointment/controllers/login_controller.dart';
import 'package:doctor_appointment/screens/sign_screen.dart';
import 'package:doctor_appointment/util/custom_button.dart';
import 'package:doctor_appointment/util/custom_text_field.dart';
import 'package:doctor_appointment/util/extension_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Login',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Colors.black, fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: controller.emailController,
              hintText: 'Email',
            ).height(60.h),
            Obx(
              () => CustomTextField(
                maxLine: 1,
                controller: controller.passwordController,
                hintText: 'Password',
                isPassword: true,
                isPasswordHidden: controller.isPasswordHidden.value,
                togglePasswordVisibility: controller.togglePasswordVisibility,
              ),
            ).height(80.h),
            Obx(
              () => CustomButton(
                isLoading: controller.isLoading.value,
                text: "Login",
                onPressed: () {
                  controller.login();
                },
              ),
            ).withSymmetricPadding(horizontal: 20),
          ],
        ).withSymmetricPadding(horizontal: 20),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don’t have an account? ',
                style: TextStyle(fontSize: 16.sp),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => SignUpScreen());
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
