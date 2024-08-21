import 'package:get/get.dart';

enum UserRole { doctor, patient }

class SelectRoleController extends GetxController {
  var selectedRole = UserRole.doctor.obs;


  void selectRole(UserRole role) {
    selectedRole.value = role;

  }
}
