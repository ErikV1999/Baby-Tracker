import 'package:baby_tracker/screens/main_menu.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddBaby extends StatefulWidget {
  const AddBaby({Key? key}) : super(key: key);

  @override
  _AddBabyState createState() => _AddBabyState();
}

class _AddBabyState extends State<AddBaby> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String gender = 'male';
  int feet = 0;
  int inches = 0;
  DateTime selectedDate = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color( 0xFFFED766),
          elevation:0.0,
          title: Text('Sign in to baby tracker'),
      ),

      body: Container(
        padding: EdgeInsets.fromLTRB(45, 30, 45, 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: <Widget>[
                    _buildName(),
                    SizedBox(height: 60.0),

                    Text(
                      'Gender:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    _buildGender(),
                    SizedBox(height: 30.0),

                    _buildHeightField(),
                    SizedBox(height: 110),

                    Row(
                      children: [
                        Text(
                            'Date of Birth:',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
                    ),



                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 45),
                child: ElevatedButton(
                  onPressed: () {
                    FirestoreDatabase().addBaby(name, gender, feet, inches, selectedDate);
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => MainMenu()),
                    );
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Name:',
        labelStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.5)
        ),
      ),

      validator: (val) => val!.isEmpty ? 'Enter a name' : null,
      onChanged: (val) {
        setState(() => name = val);
      },
    );
  }

  Widget _buildGender() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: const Text(
                'male',
              style:  TextStyle(
                fontSize: 21
              ),
            ),
            activeColor: Color(0xFF006992),
            value: 'male',
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value!;
                print(gender);
              });
            }
          ),
        ),

        Expanded(
          child: RadioListTile<String>(
            title: const Text(
                'female',
              style: TextStyle(fontSize: 21),
            ),
            activeColor: Color(0xFFDD99BB),
            value: 'female',
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value!;
                print(gender);
              });
            },
          ),
        ),
      ]
    );
  }

  Widget _buildHeightField() {
    return Row(
      children: [
        Text(
          'Height:',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left:5, bottom: 0),
            ),
            validator: (val) => val!.isEmpty ? 'Enter value: ft' : null,
            onChanged: (val) {
              setState(() {
                feet = int.parse(val);
                print("Feet: $feet");
              });
            },
          ),
        ),

        Text(
            'ft',
          style: TextStyle(fontSize: 18),
        ),

        Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 15),
          child: TextFormField(
            validator: (val) => val!.isEmpty ? 'Enter value: in' : null,
            onChanged: (val) {
              setState(() {
                inches = int.parse(val);
                print("Inches: $inches");
              });
            },
          ),
        ),
        ),

    Container(
      padding: EdgeInsets.only(right: 60),
        child: Text(
            'in',
          style: TextStyle(fontSize: 18),
        ),
    ),

      ],
    );

  }

  _showDatePicker(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2050),
    );
    if(selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }

  }


}
