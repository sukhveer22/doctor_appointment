import 'package:doctor_appointment/screens/add_doctor_screen.dart';
import 'package:doctor_appointment/screens/doctor_chat.dart';
import 'package:doctor_appointment/util/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import '../../models/chat_model.dart';
import '../home_screen.dart';

enum _SelectedTab { Home, Chat, Doctor }

class NavigationController extends GetxController {
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
    final NavigationController controller = Get.put(NavigationController());

    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          controller.selectedIndex.value = _SelectedTab.values[index];
        },
        children: [
          HomeScreen(),
          if (firebaseUser?.uid.toString() == "dAe5HGEmiGeUPB3Xjq1rSH85Rs73")
            ActiveUsersScreen(),
          AddDoctorScreen(),
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
            if (firebaseUser?.uid.toString() == "dAe5HGEmiGeUPB3Xjq1rSH85Rs73")
              BarItem(
                icon: Icons.messenger,
                title: 'Chat',
              ),
            BarItem(
              icon: CupertinoIcons.add_circled_solid,
              title: 'Doctor',
            ),
          ],
        ),
      ),
    );
  }
}
