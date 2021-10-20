import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
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
  int startHour = 0;
  int startMin = 0;
  int stopHour = 0;
  int stopMin = 0;
  int month = 0;
  int day = 0;
  int year = 0;
  int totalSleep = 0;
  String notes = 'note';
  String path = 'path';

  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        print(picked.day);
        day = picked.day;
        month = picked.month;
        year = picked.year;
      });
  }

  Future<void> _test1() async {
    final TimeOfDay? result = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if(result != null){
      setState(() {
        _selectedTime1 = result.format(context);
      }
      );
      print(result.period); // DayPeriod.pm or DayPeriod.am
      print(result.hour);
      startHour = result.hour;
      startMin = result.minute;
      print(result.minute);
    }
  }
  Future<void> _show2() async {
    final TimeOfDay? result =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        _selectedTime2 = result.format(context);
      });
      stopHour = result.hour;
      stopMin = result.minute;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    String babyPath = widget.baby;
    String path = babyPath.substring(42);
    print(babyPath);
    print(path);
    // appBar header
    return Scaffold(
        backgroundColor: Colors.white54,
        appBar: AppBar(
          //title: Text(babyPath),
          title: Text('Sleeping'),
          centerTitle: true,
          backgroundColor: Colors.yellow,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              SizedBox(height: 8.0),
              Center(
                child: Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(height:1, fontSize: 30, backgroundColor: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2.0),

                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                      'Select date'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    'Started Sleeping At:',
                    style: TextStyle(height:1, fontSize: 30, backgroundColor: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 1.0),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: Text(
                    _selectedTime1 != null ? _selectedTime1! : 'No time selected!',
                    style: TextStyle(fontSize: 30, backgroundColor: Colors.white,),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: ElevatedButton(
                    child: const Text('Show Time Picker'),
                    onPressed: () {
                      _test1();},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    'Woke Up At:',
                    style: TextStyle(height:1, fontSize: 30, backgroundColor: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 1.0),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: Text(
                    _selectedTime2 != null ? _selectedTime2! : 'No time selected!',
                    style: TextStyle(fontSize: 30, backgroundColor: Colors.white,),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: ElevatedButton(
                    child: const Text('Show Time Picker'),
                    onPressed: () {
                      _show2();},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // The validator receives the text that the user has entered.
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Notes',
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 4.0)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow, width: 4.0)
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some notes';
                    }
                    notes = value;
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        if (stopHour < startHour){
                          totalSleep = (stopHour+24) - startHour;
                        }
                        else{
                          totalSleep = stopHour - startHour;
                        }
                        FirestoreDatabase().addSleepTime(startHour, startMin, stopHour, stopMin, month, day, year, notes, path);
                        FirestoreDatabase().updateLastSleep(totalSleep, path);
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}