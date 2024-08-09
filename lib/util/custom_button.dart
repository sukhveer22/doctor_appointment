import 'package:doctor_appointment/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final double fontSize;
  final bool isLoading; // Added parameter for loading state

  CustomButton({
    required this.text,
    required this.onPressed,
    this.color = AppColors.primaryColor,
    this.textColor = Colors.white,
    this.borderRadius = 18.0,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
    this.elevation = 2.0,
    this.fontSize = 16.0,
    this.isLoading = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10.0,
            ),
          ]),
      height: 60,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Disable button when loading
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledIconColor: textColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          padding: padding,
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: AppColors.primaryColor)) // Show loading indicator
            : Text(
                text,
                style: TextStyle(
                  fontSize: fontSize.sp,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
