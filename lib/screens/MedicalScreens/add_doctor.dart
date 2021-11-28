import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDoctor extends StatefulWidget {
  final String babyPath;
  const AddDoctor({Key? key, required this.babyPath}) : super(key: key);

  @override
  _AddDoctorState createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  String doctor = '';
  String hospital = '';
  String street = '';
  String city = '';
  String state = '';
  String phone = '';
  String reasonForVisit = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('New Doctor'),
      ),

      body: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDoctorCard(),

              ElevatedButton(
                child: Text('Create'),
                onPressed: () async {
                  await saveDoctor();
                },
              ),

            ],
          ),
        ),
      ),

    );
  }

  Widget _buildDoctorCard() {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                label: Text(
                  "Doctor's Name: ",
                ),
              ),

              onChanged: (val) {
                setState(() {
                  doctor = val;
                });
              },
            ),

            TextFormField(
              decoration: InputDecoration(
                label: Text(
                    'Clinic/Hospital:'
                ),
              ),

              onChanged: (val) {
                setState(() {
                  hospital = val;
                });
              },
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Location:'),
                ],
              ),
            ),

            TextFormField(
              decoration: InputDecoration(
                hintText: 'Street',
                hintStyle: TextStyle(
                    color: Colors.black38
                ),
              ),

              onChanged: (val) {
                setState(() {
                  street = val;
                });
              },
            ),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'City',
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        city = val;
                      });
                    },
                  ),
                ),

                Padding(padding: EdgeInsets.only(right: 30)),

                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'State/Province',
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        state = val;
                      });
                    },
                  ),
                ),

              ],
            ),

            TextFormField(
              decoration: InputDecoration(
                label: Text('Phone Number'),
              ),
              onChanged: (val) {
                setState(() {
                  phone = val;
                });
              },
            ),

          ],
        ),
      ),
    );
  }


  Future saveDoctor() async {
    CollectionReference locationsRef = FirebaseFirestore.instance.doc(widget.babyPath).collection('Doctors');

    var data = {
      'doctor': doctor,
      'hospital': hospital,
      'street': street,
      'city': city,
      'state': state,
      'phone': phone,
    };

    locationsRef.add(data).whenComplete(() {
      Navigator.pop(context);
    });

  }

}


