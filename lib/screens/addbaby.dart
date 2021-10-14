import 'package:baby_tracker/screens/main_menu.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
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
          backgroundColor: Color(0xFF006992),
          elevation:0.0,
          title: Text('Sign in to baby tracker'),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20.0),
              _buildName(),

              SizedBox(height: 30.0),
              Text(
                'Gender:',
                style: TextStyle(fontSize: 25),
              ),
              _buildGender(),

              SizedBox(height: 20.0),
              _buildHeightField(),


              Container(
                padding: EdgeInsets.only(top: 40),
                child: ElevatedButton(
                    onPressed: () => _showDatePicker(context),
                    child: Text('DOB'),
                ),
              ),

              Text('${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'),

              Container(
                padding: EdgeInsets.only(top: 25),
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
            title: const Text('male'),
              value: 'male',
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value!;
                  print(gender);
                });
              },
            ),
        ),

        Expanded(
          child: RadioListTile<String>(
            title: const Text('female'),
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

        Text('ft'),

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
        child: Text('in')
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
