import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:baby_tracker/models/defaultscreen.dart';


class diaperchange extends StatefulWidget {


  final String baby; //contains the path to baby in database
  const diaperchange({Key? key, required this.baby}) : super(key: key);

  @override
  _diaperchangeState createState() => _diaperchangeState();
}

class _diaperchangeState extends State<diaperchange> {

  final _formKey = GlobalKey<FormState>();

  String status = 'Wet';                    //hold data for status of diaper(wet, dry, or mix)
  String notes = 'No notes';                //hold data for notes, defaults to No notes
  String timeFormat = '';                   //hold data in string format for printing out on confirmation to user
  DateTime selectedDate = DateTime.now();   //hold date of diaper change, default to today

  @override

  Widget build(BuildContext context) {

    String babyPath = widget.baby;            //hold path of this baby in database

    //following function sets timeFormat to user entered data to be printed back to user on confirmation
    Future<void> _changeTimeFormat() async{
      timeFormat = "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')} "
          "${selectedDate.hour.toString().padLeft(2,'0')}:${selectedDate.minute.toString().padLeft(2,'0')}";
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,     //allow page to scroll down for more information
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black,),
          title: Text('Diaper Change',
            style: TextStyle(color: DefaultScreen.appBarFont),),
        ),
        body: ListView(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap:  true,
            children: <Widget>[
              Container(
                child: Form(
                  key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text('Enter date and time of diaper change',
                          style: TextStyle(fontSize:20,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(//following has a scroll wheel for data for user to enter data, date is stored in selectedDate
                          height: 200,
                          child: CupertinoDatePicker(//Theme.of(context).accentColor,
                            backgroundColor: Colors.blueGrey[50],
                            mode: CupertinoDatePickerMode.dateAndTime,
                            initialDateTime: selectedDate,
                            onDateTimeChanged: (val) {
                              selectedDate = val;
                            },
                            use24hFormat: false,
                            minuteInterval: 1,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Wrap(
                            children: <Widget>[
                              //following has 3 buttons from user to choose for status of diaper, clicking on one sets status to equal the string on that button,
                              //defaults to Wet
                              Text('Please choose best description',
                                style: TextStyle(fontSize:20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue[500],
                                ),
                                child: Text(
                                  'Wet',
                                  style: TextStyle(),
                                ),
                                onPressed: () async {
                                  status = 'Wet';
                                  //print(status);
                                },
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.brown[500],
                                  ),
                                  child: Text(
                                    'Dry',
                                    style: TextStyle(),
                                  ),
                                  onPressed: () async {
                                    status = 'Dry';
                                    //print(status);
                                  }
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.lightGreen[800],
                                  ),
                                  child: Text(
                                    'Mix',
                                    style: TextStyle(),
                                  ),
                                  onPressed: () async {
                                    status = 'Mix';
                                  }
                              ),

                            ]
                        ),
                        TextFormField(
                          maxLines: 1,
                          decoration: InputDecoration( //prompts user to enter characters for notes, if no data is entered then defaults to No notes
                              labelText: 'Notes'
                          ),
                          validator: (val) => val!.isEmpty ? 'Notes' : null,
                          onChanged: (val) {
                            setState(() => notes = val);
                          },
                        ),
                        SizedBox(height: 100.0,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                _changeTimeFormat();
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        // Shows user the information they entered if they click ok then enters data
                                        title: const Text('Review Diaper Change Information'),
                                        content: Text('Date: $timeFormat\n'
                                                      'Status: $status\n'
                                                      'Notes: $notes\n'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              _changeTimeFormat();
                                              Navigator.pop(context, 'Cancel');
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _changeTimeFormat();
                                              Navigator.pop(context, 'OK');
                                              FirestoreDatabase().addDiaper(selectedDate, notes, status, babyPath);
                                              FirestoreDatabase().updatediaperchange(selectedDate, notes, status, babyPath);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              // Following is a button for user to submit information to database, a box pops up to ask if they want to confirm information
                              child: const Text('Submit Sleeping Information',
                                style: TextStyle(fontSize: 25),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                              ),
                            ),
                          ),
                        ),
                      ]
                    ),
                ),
              ),
            ]
        ),
    );
  }
}
