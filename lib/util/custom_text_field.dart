import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? maxLine;
  final bool isPassword;
  final TextInputType? keyboardType;
  final bool isPasswordHidden;
  final VoidCallback? togglePasswordVisibility;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final Widget? prefixIcon;

  CustomTextField({
    required this.controller,
    this.hintText,
    this.isPassword = false,
    this.isPasswordHidden = false,
    this.togglePasswordVisibility,
    this.onChanged,
    this.validator,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = Colors.blue,
    this.errorBorderColor = Colors.red,
    this.prefixIcon,
    this.keyboardType,
    this.maxLine = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLine,
      obscureText: isPassword ? isPasswordHidden : false,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: togglePasswordVisibility,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: focusedBorderColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: errorBorderColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: errorBorderColor,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
