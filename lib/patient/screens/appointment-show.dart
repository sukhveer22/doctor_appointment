import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:doctor_appointment/models/appointent_model.dart';
import 'package:intl/intl.dart'; // For date formatting

class AppointmentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('appointments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No appointments found.'));
          }

          final appointments = snapshot.data!.docs
              .map((doc) =>
                  AppointmentModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: appointment.doctorImage.toString().isNotEmpty
                      ? AssetImage(appointment.doctorImage.toString())
                      : NetworkImage(
                          'https://via.placeholder.com/150'), // Placeholder if image URL is empty
                ),
                title: Text(appointment.doctorName.toString()),
                subtitle: Text(
                  'Appointment with ${appointment.userName} on ${DateFormat.yMMMd().format(appointment.appointmentDate as DateTime)}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
