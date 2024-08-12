import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String appointmentid;
  final String doctorName;
  final String userName;
  final String userImage;
  final String doctorId;
  final DateTime appointmentDate;
  final String doctorImage;

  AppointmentModel({
    required this.appointmentid,
    required this.doctorName,
    required this.userName,
    required this.userImage,
    required this.doctorId,
    required this.appointmentDate,
    required this.doctorImage,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      appointmentid: map['appointmentid'] as String? ?? '',
      doctorName: map['doctorName'] as String? ?? 'Unknown Doctor',
      userName: map['userName'] as String? ?? 'Unknown User',
      userImage: map['userImage'] as String? ?? '',
      doctorId: map['doctorId'] as String? ?? '',
      appointmentDate: map['appointmentDate'] != null
          ? (map['appointmentDate'] is Timestamp
          ? (map['appointmentDate'] as Timestamp).toDate()
          : DateTime.tryParse(map['appointmentDate'] as String) ?? DateTime.now())
          : DateTime.now(),
      doctorImage: map['doctorImage'] as String? ?? '', // Ensure this is a valid string
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointmentid': appointmentid,
      'doctorName': doctorName,
      'userName': userName,
      'userImage': userImage,
      'doctorId': doctorId,
      'appointmentDate': DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day).toIso8601String(),
      'doctorImage': doctorImage,
    };
  }
}
