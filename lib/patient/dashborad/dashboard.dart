import 'package:doctor_appointment/doctor/screens/profile_screens/dcotor-mian-profile.dart';
import 'package:doctor_appointment/patient/screens/add_doctor_screen.dart';
import 'package:doctor_appointment/patient/screens/appointment-show.dart';
import 'package:doctor_appointment/util/all_chat.dart';
import 'package:doctor_appointment/patient/screens/appointment_screen.dart';
import 'package:doctor_appointment/util/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import '../../models/chat_model.dart';
import '../../util/doctor_util.dart';
import '../screens/home_screen.dart';

enum _SelectedTab { Home, Chat, Appointment, Profile }

class PatientNavigationController extends GetxController {
  final PageController pageController = PageController();
  var selectedIndex = _SelectedTab.Home.obs;

  void changeTab(_SelectedTab tab) {
    selectedIndex.value = tab;
    pageController.animateToPage(
      _SelectedTab.values.indexOf(tab),
      duration: const Duration(milliseconds: 1),
      curve: Curves.easeOutQuad,
    );
  }
}

class DashboardScreen extends StatelessWidget {
  DashboardScreen({
    super.key,
  });

  final ChatRoomModel chatroom = ChatRoomModel();
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final PatientNavigationController controller =
        Get.put(PatientNavigationController());

    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          controller.selectedIndex.value = _SelectedTab.values[index];
        },
        children: [
          HomeScreen(),
          AllChatScreen(),
          AppointmentListScreen(),
          AllProfile()
        ],
      ),
      bottomNavigationBar: Obx(
        () => SlidingClippedNavBar(
          backgroundColor: AppColors.primaryColor,
          onButtonPressed: (index) {
            controller.changeTab(_SelectedTab.values[index]);
          },
          iconSize: 30,
          activeColor: Colors.white,
          inactiveColor: Colors.white,
          selectedIndex: _SelectedTab.values.indexOf(
            controller.selectedIndex.value,
          ),
          barItems: [
            BarItem(
              icon: CupertinoIcons.house_alt_fill,
              title: 'Home',
            ),
            BarItem(
              icon: CupertinoIcons.chat_bubble_fill,
              title: 'Chat',
            ),
            BarItem(
              icon: Icons.book,
              title: "Appointment",
            ),
            BarItem(
              icon: Icons.person,
              title: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
