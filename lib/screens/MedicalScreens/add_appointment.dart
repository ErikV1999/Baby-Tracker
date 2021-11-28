import 'package:baby_tracker/screens/MedicalScreens/add_doctor.dart';
import 'package:baby_tracker/screens/MedicalScreens/schedule_appointment.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAppointment extends StatefulWidget {
  final String babyPath;
  const AddAppointment({Key? key, required this.babyPath}) : super(key: key);

  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {

  @override
  Widget build(BuildContext context) {
    CollectionReference doctorsCollection = FirebaseFirestore.instance.doc(widget.babyPath).collection('Doctors');

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
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddDoctor(babyPath: widget.babyPath)),
                    );
                    setState(() {});
                  },
                  icon: Icon(Icons.add),
                  iconSize: 45,
                ),
              ],
            ),

            FutureBuilder<QuerySnapshot>(
              future: doctorsCollection.get(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map data = snapshot.data!.docs[index].data() as Map;
                      String docID = snapshot.data!.docs[index].id;
                      DocumentReference doctorRef = doctorsCollection.doc(docID);
                      String doctorPath = doctorRef.path;

                      return _buildDoctorCard(data, doctorPath);
                    },
                  );
                } else {
                  return Text('No Doctors saved');
                }
              },
            ),

          ],
        ),
      ),

    );
  }

  Widget _buildDoctorCard(Map data, String doctorPath) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Doctor:\t${data['doctor']}",
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
              '\t\t\t${data['hospital']}',
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
              '\t\t${data['street']}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              '\t\t${data['city']}, ${data['state']}',
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
              '\t\t${data['phone']}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScheduleAppointment(doctor: data, doctorPath: doctorPath, babyPath: widget.babyPath,)),
                    );
                  },
                  icon: Icon(Icons.add_alarm),
                  iconSize: 35,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

}

