import 'package:doctor_appointment/patient/dashborad/dashboard.dart';
import 'package:doctor_appointment/role_method/select_role_controller.dart';
import 'package:doctor_appointment/role_method/select_role_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:doctor_appointment/firebase_options.dart';
import 'package:doctor_appointment/util/app_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'doctor/screens/dahsborad/doctor-dashborad.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SelectRoleController userrole = Get.put(SelectRoleController());
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, child) {
        AppConfig.init(context);

        return GetMaterialApp(
          theme: ThemeData(
            focusColor: Colors.white,
          ),
          home: _getInitialScreen(userrole),
        );
      },
    );
  }

  Widget _getInitialScreen(SelectRoleController userrole) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if(userrole.selectedRole.value == UserRole.doctor){
        return Doctordashborad();
      } else {
        return DashboardScreen();
      }
    } else {
      return SelectRoleScreen();
    }
  }
}
