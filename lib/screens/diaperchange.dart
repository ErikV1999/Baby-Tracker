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
  String status = '';
  String notes = '';
  String path = 'path';

  DateTime selectedDate = DateTime.now();

  @override


  Widget build(BuildContext context) {

    String babyPath = widget.baby;
    String path = babyPath.substring(42);


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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: DefaultScreen.appBarBackground,
                            ),
                          child: Text(
                            'Add Diaper Change',
                            style: TextStyle(),
                          ),
                          onPressed: () async{
                          /*print(notes);
                          print(status);
                          print(selectedDate);*/
                          FirestoreDatabase().addDiaper(selectedDate, notes, status, babyPath);
                          FirestoreDatabase().updatediaperchange(selectedDate, notes, status, babyPath);
                          },
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
