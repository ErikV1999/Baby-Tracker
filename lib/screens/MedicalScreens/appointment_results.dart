import 'package:baby_tracker/screens/MedicalScreens/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentResults extends StatefulWidget {
  final Appointment appointment;
  final String babyPath;
  const AppointmentResults({Key? key, required this.appointment, required this.babyPath}) : super(key: key);

  @override
  _AppointmentResultsState createState() => _AppointmentResultsState();
}

class _AppointmentResultsState extends State<AppointmentResults> {
  TextEditingController reasonForVisit = TextEditingController();
  TextEditingController results = TextEditingController();
  late DocumentReference appointmentRef;
  @override
  void initState() {
    reasonForVisit = TextEditingController(text: widget.appointment.reasonForVisit);
    results = TextEditingController(text: widget.appointment.results);
    appointmentRef = FirebaseFirestore.instance.doc(widget.babyPath).collection('DocAppointments').doc(widget.appointment.notificationID.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat.yMMMd().add_jm().format(widget.appointment.time);

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment'),
        actions: [
          buildDeleteButton(),
          buildSaveButton(),
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              _buildDoctorCard(formattedTime),

              Container(
                padding: EdgeInsets.all(10),
                child: _buildReasonForVisit(),
              ),

              Container(
                padding: EdgeInsets.all(10),
                child: _buildResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard(String formattedTime) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Doctor:\t${widget.appointment.doctor}",
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
              '\t\t\t${widget.appointment.hospital}',
              style: TextStyle(
                fontSize: 18
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
              '\t\t${widget.appointment.street}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              '\t\t${widget.appointment.city}, ${widget.appointment.state}',
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
              '\t\t${widget.appointment.phone}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            Container(
              padding: EdgeInsets.only(top: 10),
              alignment: AlignmentDirectional.bottomEnd,
              child: Text(
                formattedTime,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonForVisit() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Reason For Visit',
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
      controller: reasonForVisit,
      onChanged: (val) {},
    );
  }

  Widget _buildResults() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Results',
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
      controller: results,
      onChanged: (val) {},
    );
  }

  Widget buildSaveButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 12, 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent),
        child: Text(
          'Save',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => {updateNote()},  //calls update note on press
      ),
    );
  }

  void updateNote() {
   appointmentRef.update({
     'reasonForVisit': reasonForVisit.text,
     'results': results.text,
   });
   Navigator.pop(context);
  }

  Widget buildDeleteButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 12, 10),
      child: ElevatedButton(
        child: Icon(Icons.delete, color: Colors.white,),
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
        ),
        onPressed: () => {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Confirm Deletion'),
                content: Text('Confirm deletion of appointment'),
                actions: [
                  TextButton(
                    child: Text('Confirm'),
                    onPressed: () {
                      appointmentRef.delete().whenComplete(() => Navigator.pop(context))
                        .then((value) => Navigator.pop(context));
                    },
                  ),

                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          ),
        },
      ),
    );
  }

}
