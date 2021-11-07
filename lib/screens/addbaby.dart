import 'package:baby_tracker/screens/main_menu.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
    Takes in baby's name, gender, height, and date of birth.
    Then pushes it to the users Baby collection.
 */
class AddBaby extends StatefulWidget {

  final String userEntry;

  const AddBaby({Key? key, required this.userEntry}) : super(key: key);

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

  //creates date picker and assigns chosen date to selectedDate variable
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color( 0xFFFED766),
          elevation:0.0,
          title: Text('Sign in to baby tracker'),
      ),

      body: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/tempBabyLogo.png'),
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
            )
        ),
        padding: EdgeInsets.fromLTRB(45, 30, 45, 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildName(),
              SizedBox(height: 60.0),

              Text(
                'Gender:',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              _buildGender(),
              SizedBox(height: 50.0),

              _buildHeightField(),
              SizedBox(height: 60),

              _buildDate(),

              SizedBox(height: 100),
              _buildSignInButton(),

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
          color: Theme.of(context).textTheme.bodyText1!.color,
          fontSize: 24,
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
            fontSize: 24,
          ),
        ),

        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left:5, bottom: 0),
              errorMaxLines: 3,
            ),
            validator: (val) {
              if(val!.isEmpty) {
                return 'Enter value: ft';
              }
              var number = int.tryParse(val);
              if(number == null) {
                return 'Enter a number';
              }
            },
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
            decoration: InputDecoration(
              errorMaxLines: 3,
            ),
            validator: (val) {
              if(val!.isEmpty) {
                return 'Enter value: ft';
              }
              var number = int.tryParse(val);
              if(number == null) {
                return 'Enter a number';
              }

              if(number <0 || number > 11) {
                return 'Enter number 0-11';
              }
            },
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
      padding: EdgeInsets.only(right: 70),
        child: Text(
            'in',
          style: TextStyle(fontSize: 18),
        ),
    ),

      ],
    );

  }

  Widget _buildDate() {
    return              Row(
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


  Widget _buildSignInButton() {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          if(_formKey.currentState!.validate()) {
            FirestoreDatabase().addBaby(name, gender, feet, inches, selectedDate, widget.userEntry);
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => MainMenu()),
            );
          }

        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(0),
          fixedSize: Size(40,60),
          primary: Color(0xFF006992),
        ),
        child: Text(
            'Submit',
          style: TextStyle(fontSize: 20)
        ),
      ),
    );

  }


}
