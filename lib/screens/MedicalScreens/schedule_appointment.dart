import 'dart:math';

import 'package:baby_tracker/screens/MedicalScreens/medical_menu.dart';
import 'package:baby_tracker/screens/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleAppointment extends StatefulWidget {
  final Map doctor;
  final String doctorPath;
  final String babyPath;

  const ScheduleAppointment({Key? key, required this.doctor, required this.doctorPath, required this.babyPath}) : super(key: key);

  @override
  _ScheduleAppointmentState createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String reasonForVisit = '';
  

  @override
  Widget build(BuildContext context) {
    final Map doctor = widget.doctor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Appointment'),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      selectDate(context);
                    },
                    child: ListTile(
                      title: Text(
                        DateFormat.yMMMd().format(selectedDate),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),

                Expanded(
                  child: InkWell(
                    onTap: () {
                      selectTime(context);
                    },
                    child: ListTile(
                      title: Text(
                        selectedTime.format(context),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),

              ],
            ),

            _buildDoctorCard(doctor),
            _buildTextBox(),

            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                onPressed: () {
                  scheduleAppointment();
                },
                child: Text('Schedule'),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildDoctorCard(Map doctor) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Doctor:\t${doctor['doctor']}",
              style: TextStyle(
                fontSize: 25,
                decoration: TextDecoration.underline,
              ),
            ),


            Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Clinic/Hospital:',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Text(
              '\t\t\t${doctor['hospital']}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Location:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\t\t${doctor['street']}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              '\t\t${doctor['city']}, ${doctor['state']}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Phone Number:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '\t\t${doctor['phone']}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildTextBox() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Reason for Visit',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).dividerColor,
            style: BorderStyle.solid,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).dividerColor,
            style: BorderStyle.solid,
          ),
        ),

      ),
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 10,

      onChanged: (val) {
        reasonForVisit = val;
      },
    );
  }

  void scheduleAppointment() async {
    CollectionReference appointmentRef = FirebaseFirestore.instance.doc(widget.babyPath).collection('DocAppointments');
    DateTime combinedTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
    Random random = new Random();
    int notificationID = random.nextInt(9999);
    var data = {
      'doctorPath': widget.doctorPath,
      'time': combinedTime,
      'notificationID': notificationID,
      'reasonForVisit': reasonForVisit,
      'results': '',
    };

    if(combinedTime.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) {
      String formattedDate = DateFormat.yMMMd().add_jm().format(combinedTime);
      NotificationService().scheduleNotification(
        title: 'Doctor Appointment Reminder',
        body: 'Appointment at ${formattedDate}',
        scheduledDate: combinedTime.add(Duration(seconds: 10)),
      );

      await appointmentRef.doc(notificationID.toString()).set(data).whenComplete(() {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }else {
      print('Appointment set before or current time');
    }


  }

  void selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    
    if(selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  void selectTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if(selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
  }


}
