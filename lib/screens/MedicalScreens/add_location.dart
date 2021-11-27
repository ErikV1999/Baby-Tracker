import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddLocation extends StatefulWidget {
  final String babyPath;
  const AddLocation({Key? key, required this.babyPath}) : super(key: key);

  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
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
        title: Text('Records'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
          child: Column(
            children: [
              _buildLocationCard(),

              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                child: _buildTextBox(),
              ),

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

  Widget _buildLocationCard() {
    return Card(
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

  Widget _buildTextBox() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Reason For Visit',
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


