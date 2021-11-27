import 'package:baby_tracker/screens/MedicalScreens/add_location.dart';
import 'package:flutter/material.dart';

class AddAppointment extends StatefulWidget {
  final String babyPath;
  const AddAppointment({Key? key, required this.babyPath}) : super(key: key);

  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records'),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddLocation(babyPath: widget.babyPath)),
                    );
                  },
                  icon: Icon(Icons.add),
                  iconSize: 45,
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}

