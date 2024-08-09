import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:doctor_appointment/firebase_options.dart';
import 'package:doctor_appointment/screens/dashborad/dashboard.dart';
import 'package:doctor_appointment/screens/login_screen.dart';
import 'package:doctor_appointment/screens/sign_screen.dart';
import 'package:doctor_appointment/util/app_config.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppConfig.init(context);
    });

    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, child) {
        return GetMaterialApp(
          theme: ThemeData(
            focusColor: Colors.white,
          ),
          home: _getInitialScreen(),
        );
      },
    );
  }

  Widget _getInitialScreen() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return DashboardScreen();
    } else {
      return LoginScreen();
    }
  }
}
