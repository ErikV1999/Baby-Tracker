import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:baby_tracker/models/defaultscreen.dart';


class diaperchange extends StatefulWidget {


  final String baby;
  const diaperchange({Key? key, required this.baby}) : super(key: key);

  @override
  _diaperchangeState createState() => _diaperchangeState();
}

class _diaperchangeState extends State<diaperchange> {

  final _formKey = GlobalKey<FormState>();


  String dateD = '';
  String timeD = '';
  String status = 'Wet';
  String notes = 'No notes';
  String path = 'path';
  String timeFormat = '';


  DateTime selectedDate = DateTime.now();

  @override


  Widget build(BuildContext context) {

    String babyPath = widget.baby;
    String path = babyPath.substring(42);

    Future<void> _changeTimeFormat() async{
      timeFormat = "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')} "
          "${selectedDate.hour.toString().padLeft(2,'0')}:${selectedDate.minute.toString().padLeft(2,'0')}";

    }

    return Scaffold(
      // resizeToAvoidBottonInset use to fix overflow by X pixels
      resizeToAvoidBottomInset: true,
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
                        Container(
                          height: 200,
                          child: CupertinoDatePicker(
                            backgroundColor: Theme.of(context).accentColor,
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
                          decoration: InputDecoration(
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
