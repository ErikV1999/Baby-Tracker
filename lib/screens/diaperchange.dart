import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';

class diaperchange extends StatefulWidget {
  const diaperchange({Key? key}) : super(key: key);

  @override
  _diaperchangeState createState() => _diaperchangeState();
}

class _diaperchangeState extends State<diaperchange> {

  final _formKey = GlobalKey<FormState>();

  String dateD = '';
  String timeD = '';
  String status = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black,),
        title: Text('Diaper Change',
          style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.yellow[300],
        ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                  TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter Date (mm/dd/yy)'
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter a date(mm/dd/yy)' : null,
                  onChanged: (val) {
                    setState(() => dateD = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Enter Time (hour:minutes am/pm)'
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter a date(mm/dd/yy)' : null,
                  onChanged: (val) {
                    setState(() => timeD = val);
                  },
                ),

                SizedBox(height: 20.0),
                Wrap(
                  children: <Widget>[
                    Text('status'),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[500],
                      ),
                      child: Text(
                        'Wet',
                      style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        status = 'Wet';
                        print(status);
                      },
                    ),
                      SizedBox(width: 10),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.brown[500],
                          ),
                          child: Text(
                            'Dry',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            status = 'Dry';
                            print(status);
                          }
                      ),
                    SizedBox(width: 10),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen[800],
                        ),
                        child: Text(
                          'Mix',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          status = 'Mix';
                          print(status);
                        }
                    ),
                  ]
                ),
                //add a notes input
                //STOPPED HERE 10/15
                Text('Notes__________________________________________'),
                SizedBox(height: 100.0,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow[500],
                  ),
                  child: Text(
                    'Enter Data',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async{
                    print(dateD);
                    print(timeD);
                  },
                ),
                ],
            ),
        ),
      ),
    );
  }
}
