import 'package:baby_tracker/models/Themes/changeTheme.dart';
import 'package:baby_tracker/screens/MedicalScreens/add_appointment.dart';
import 'package:baby_tracker/screens/services/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class Medical_Menu extends StatefulWidget {
  final String babyPath;

  const Medical_Menu({Key? key, required this.babyPath}) : super(key: key);

  @override
  _Medical_MenuState createState() => _Medical_MenuState();
}

class _Medical_MenuState extends State<Medical_Menu> {
  DateTime selectedDate = DateTime.now();

  void _showDatePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
          height: 500,
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              Container(
                height: 400,
                child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (val) {
                      setState(() {
                        selectedDate = val;
                      });
                    }),
              ),

              // Close the modal
              CupertinoButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(ctx).pop(),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical'),
        actions: [
          ChangeThemeButton(),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddAppointment(babyPath: widget.babyPath,)),
          );
        },
      ),


    );
  }


  Widget _buildDate() {
    return  Row(
      children: [
        Text(
          'Date of Birth:',
          style: TextStyle(
            fontSize: 24,
          ),
        ),

        Container(
          padding: EdgeInsets.fromLTRB(20, 10, 40, 0),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () => _showDatePicker(context),
                label: Text(''),
                icon: Icon(
                  Icons.calendar_today_sharp,
                  size:28,
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                    fixedSize: Size(50, 50),
                    primary: Color(0xFF006992)
                ),
              ),

              Text('${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSchedulingButton() {
    return  ElevatedButton(
      onPressed: () {
        //DateFormat.yMMMd().add_jm().format(date),
        String formatedDate = DateFormat.yMMMd().add_jm().format(selectedDate);
        NotificationService().scheduleNotification(
          title: 'Doctor Appointment Reminder',
          body: 'Appointment at ${formatedDate}',
          scheduledDate: selectedDate.add(Duration(seconds: 10)),
        );
      },
      child: Text('Schedule'),
    );
  }

}

