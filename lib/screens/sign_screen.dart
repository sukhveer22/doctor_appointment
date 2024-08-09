import 'package:doctor_appointment/controllers/sign_controller.dart';
import 'package:doctor_appointment/screens/login_screen.dart';
import 'package:doctor_appointment/util/app_config.dart';
import 'package:doctor_appointment/util/custom_button.dart';
import 'package:doctor_appointment/util/custom_text_field.dart';
import 'package:doctor_appointment/util/extension_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(

            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                        controller: controller.nameController,
                        hintText: 'Name',
                      ).height(50.h),

                      CustomTextField(
                        controller: controller.emailController,
                        hintText: 'Email',
                      ).height(50.h),

                      SizedBox(height: 16.h),

                      Obx(
                        () => CustomTextField(
                          controller: controller.passwordController,
                          hintText: 'Password',
                          isPassword: true,
                          isPasswordHidden: controller.isPasswordHidden.value,
                          togglePasswordVisibility:
                              controller.togglePasswordVisibility,
                        ),
                      ).height(50.h),

                      Obx(
                        () => CustomButton(
                          text: 'Sign Up',
                          onPressed: controller.signUp,
                          isLoading: controller.isLoading.value,
                        ),
                      ).withSymmetricPadding(vertical: 20.h),

                      Text(
                        'By signing up, you agree to our Terms and Conditions and Privacy Policy.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ).withPadding(top: 8.h),

                      SizedBox(height: 20.h),

                      // Sign Up with Google button (optional)
                      // CustomButton(
                      //   text: 'Sign Up with Google',
                      //   onPressed: controller.signInWithGoogle,
                      //   color: Colors.red,
                      // ).withSymmetricPadding(vertical: 20.h),
                    ],
                  ),
                );
              }
            }),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don’t have an account? ',
                style: TextStyle(fontSize: 16.sp),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => LoginScreen());
                },
                child: Text(
                  'Log In',
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
