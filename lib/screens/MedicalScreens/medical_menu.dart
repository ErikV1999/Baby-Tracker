import 'package:baby_tracker/models/Themes/changeTheme.dart';
import 'package:baby_tracker/screens/MedicalScreens/add_appointment.dart';
import 'package:baby_tracker/screens/MedicalScreens/appointment_results.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:baby_tracker/screens/MedicalScreens/appointment.dart';

class Medical_Menu extends StatefulWidget {
  final String babyPath;

  const Medical_Menu({Key? key, required this.babyPath}) : super(key: key);

  @override
  _Medical_MenuState createState() => _Medical_MenuState();
}

class _Medical_MenuState extends State<Medical_Menu> {
  DateTime selectedDate = DateTime.now();
  late Future loadFuture;


  Future<List<Appointment>> loadData() async {
    CollectionReference appointmentRef = FirebaseFirestore.instance.doc(widget.babyPath).collection('DocAppointments');
    QuerySnapshot appointmentSnap = await appointmentRef.get();
    List<Appointment> appointmentList = [];

    List<Map> appointmentData = [];
    appointmentSnap.docs.forEach((snapshot) {
      appointmentData.add(snapshot.data() as Map);
    });

    DocumentSnapshot doctorSnap;
    List<Map> doctorList = [];
    for(var element in appointmentData) {
      DocumentReference doctorRef = FirebaseFirestore.instance.doc(element['doctorPath']);
      doctorSnap = await doctorRef.get();
      Appointment appointment = Appointment(element, doctorSnap.data() as Map);
      appointmentList.add(appointment);
    }
    print(appointmentList);
    return appointmentList;

  }

  @override void initState() {
    super.initState();
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
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddAppointment(babyPath: widget.babyPath,)),
          );
          setState(() {});
        },
      ),

      body: FutureBuilder<List<Appointment>>(
        future: loadData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container(child: CircularProgressIndicator(),),);
          }

          if(snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Appointment appointment = snapshot.data![index];
                return Container(
                    padding: EdgeInsets.only(top: 10),
                    child: _buildDoctorCard(appointment),
                );
              },
            );
          } else {
            return Text('No appointments');
          }
        }
      ),

    );
  }

  Widget _buildDoctorCard(Appointment appointment) {
    String formattedTime = DateFormat.yMMMd().add_jm().format(appointment.time);

    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppointmentResults(appointment: appointment, babyPath: widget.babyPath,)),
        );
        setState(() {});
      },
      child: Card(
        color: Theme.of(context).primaryColor,
        child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Doctor:\t${appointment.doctor}",
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
                '\t\t\t${appointment.hospital}',
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
      ),
    );
  }


}

