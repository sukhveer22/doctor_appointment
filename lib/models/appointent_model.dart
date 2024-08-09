class AppointmentModel {
  final String id;
  final String doctorName;
  final String doctorImage;
  final String patientId;
  final DateTime appointmentDate;

  AppointmentModel({
    required this.id,
    required this.doctorName,
    required this.doctorImage,
    required this.patientId,
    required this.appointmentDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorName': doctorName,
      'doctorImage': doctorImage,
      'patientId': patientId,
      'appointmentDate': appointmentDate.toIso8601String(),
    };
  }
}
