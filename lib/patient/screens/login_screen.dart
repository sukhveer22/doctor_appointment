import 'package:doctor_appointment/patient/controllers/login_controller.dart';
import 'package:doctor_appointment/patient/screens/sign_screen.dart';
import 'package:doctor_appointment/util/appTextStyle.dart';
import 'package:doctor_appointment/util/app_color.dart';
import 'package:doctor_appointment/util/custom_button.dart';
import 'package:doctor_appointment/util/custom_text_field.dart';
import 'package:doctor_appointment/util/extension_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                Image(
                  image: AssetImage(
                    "assets/login-removebg-preview.png",
                  ),
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 25.h),
                _buildTextField(
                    'Email', controller.emailController, 'Enter your Email',
                    condd: controller),
                _buildTextField('Password', controller.passwordController,
                    'Enter your Password',
                    isPassword: true, condd: controller),
                SizedBox(height: 20.h),
                Center(
                  child: Obx(
                    () => CustomButton(
                      text: 'Log In',
                      color: Colors.white,
                      onPressed: controller.login,
                      isLoading: controller.isLoading.value,
                      textStyle: AppTextStyles.header,
                      textColor: Colors.black,
                      fontSize: 20,
                    ),
                  ).withSymmetricPadding(vertical: 20.h),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an account? ',
                        style: AppTextStyles.header,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => SignUpScreen());
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTextStyles.header.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hint,
      {int maxLines = 1,
      bool isPassword = false,
      required LoginController condd}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.header,
        ).paddingOnly(bottom: 5.h),
        CustomTextField(
          togglePasswordVisibility: condd.togglePasswordVisibility,
          focusedBorderColor: Colors.white,
          borderColor: Colors.white,
          controller: controller,
          hintText: hint,
          maxLine: maxLines,
          isPassword: isPassword,
          hintStyle: AppTextStyles.hint,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
