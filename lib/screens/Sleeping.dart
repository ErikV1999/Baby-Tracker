import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class Sleeping extends StatefulWidget {

  final String baby;

  const Sleeping({Key? key, required this.baby}) : super(key: key);
  @override
  _SleepingState createState() => _SleepingState();
}

  // Create a corresponding State class.
  // This class holds data related to the form.
class _SleepingState extends State<Sleeping> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  String? _selectedTime1;
  String? _selectedTime2;
  int time1Hour = 0;
  int time1Min = 0;
  int time2Hour = 0;
  int time2Min = 0;
  String? _Time3;
  int totalSleep = 0;
  String notes = 'empty!';
  String path = 'path';
  Color blueSapphire = Color(0xFF006992);
  Color orangeYellow = Color(0xFFFED766);
  TimeOfDay updateTime = TimeOfDay.now();
  TimeOfDay time1 = TimeOfDay.now();
  TimeOfDay time2 = TimeOfDay.now();
  double doubleT1 = 0;
  double doubleT2 = 0;
  double doubleT3 = 0;
  int totalHour = 0;
  int totalMin = 0;
  String Date1 = '';
  String Date2 = '';
  String Date3 = '';
  String conDate = '';
  int indexDate = 0;

  DateTime _selectedDate = DateTime.now();
  DateFormat formatter = DateFormat('MM-dd-yyyy');
  String? _dateString;
  void _presentDatePicker() {
    // showDatePicker is a pre-made funtion of Flutter
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now())
        .then((pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        return;
      }
      setState(() {
        // using state so that the UI will be rerendered when date is picked
        _selectedDate = pickedDate;
        _dateString = formatter.format(_selectedDate);
        print(_dateString);
        print(_dateString!.substring(3, 5));
        Date1 = _dateString.toString().substring(0,2);
        Date2 = _dateString.toString().substring(3,5);
        Date3 = _dateString.toString().substring(6,10);
        conDate = Date1 + Date2 + Date3;
        print(conDate);
        indexDate = int.parse(conDate);
        print(indexDate);
        //_dateString = "${_selectedDate.month.toString()}-${_selectedDate.day.toString()}-${_selectedDate.year.toString()}";
      });
    });
  }

  Future<void> _test1() async {
    final TimeOfDay? result = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if(result != null){
      setState(() {
        _selectedTime1 = result.format(context);
        time1 = result;
      }
      );
      updateTime = TimeOfDay.now();
      print(_selectedTime1);
      print(time1);
      print(updateTime);
    }
  }
  Future<void> _show2() async {
    final TimeOfDay? result =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        _selectedTime2 = result.format(context);
        time2 = result;
      });
    }
  }

  //getting the elapsed time from the start sleeping time and
  //the woke up time.
  void elapsedTime(){
    //print(time1.toString().substring(13,15));
    time1Hour = int.parse(time1.toString().substring(10,12));
    time1Min = int.parse(time1.toString().substring(13,15));
    time2Hour = int.parse(time2.toString().substring(10,12));
    time2Min = int.parse(time2.toString().substring(13,15));

    totalHour = time2Hour - time1Hour;
    if (time1Min > time2Min){
      time1Min = time1Min - 60;
    }
    totalMin = time2Min - time1Min;


    print("$totalHour , $totalMin");
    return;
}

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    String babyPath = widget.baby;
    String path = babyPath.substring(42);
    // appBar header
    return Scaffold(
        appBar: AppBar(
          //title: Text(babyPath),
          title: Text('Sleeping',
          style: TextStyle(color: Colors.black, fontSize: 30,),
          ),
          centerTitle: true,
          backgroundColor: orangeYellow,

        ),
        body: Form(
          key: _formKey,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: Text(
                            _dateString != null ? _dateString! : 'No Date selected!',
                            //"${selectedDate.toLocal()}".split(' ')[0],
                            style: TextStyle(fontSize: 25),
                          ),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: ElevatedButton.icon(
                          onPressed: () => _presentDatePicker(),
                          label: Text('Date Picker'),
                          style: ElevatedButton.styleFrom(
                            primary: blueSapphire,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          ),
                          icon: Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.black,
                        ),
                      ),
                      ),
                  ),
                    ],
                  ),
              Divider(
                thickness: 2.0,
                color: blueSapphire,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                        'Started Sleeping At:',
                        style: TextStyle(height:1, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 2.0,color: blueSapphire,),
                      ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        _selectedTime1 != null ? _selectedTime1! : 'No time selected!',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: ElevatedButton.icon(
                        onPressed: () => _test1(),
                        label: Text('Time Picker'),
                        style: ElevatedButton.styleFrom(
                          primary: blueSapphire,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        ),
                        icon: Icon(
                          Icons.access_time,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 2.0,
                color: blueSapphire,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Center(
                      child: Text(
                        'Woke Up At:',
                        style: TextStyle(height:1, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 2.0,color: blueSapphire,),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        _selectedTime2 != null ? _selectedTime2! : 'No time selected!',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: ElevatedButton.icon(
                        onPressed: () => _show2(),
                        label: Text('Time Picker'),
                        style: ElevatedButton.styleFrom(
                          primary: blueSapphire,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        ),
                        icon: Icon(
                          Icons.access_time,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 2.0,
                color: blueSapphire,
              ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Notes',
                        //fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF006992), width: 4.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFED766), width: 4.0),
                        ),
                      ),
                      onChanged: (text) {
                        notes = text;
                      },
                    ),
                  ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>
                              AlertDialog(
                                title: const Text('Review Sleeping Information'),
                                content: Text('Date: $_dateString\n'
                                    'Started Sleeping: $_selectedTime1\n'
                                    'Woke Up At: $_selectedTime2\n'
                                    'Notes: $notes'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      elapsedTime();
                      Navigator.pop(context, 'Cancel');
                      },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      elapsedTime();
                                    Navigator.pop(context, 'OK');
                                    FirestoreDatabase().addSleepTime(_dateString, _selectedTime1, _selectedTime2, totalHour, totalMin, indexDate, notes, babyPath);
                                    //FirestoreDatabase().updateLastSleep(updateTime, path);
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
                      primary: blueSapphire,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                      ),
                      ),
    ),
            ],
          ),
        )
    );
  }
}