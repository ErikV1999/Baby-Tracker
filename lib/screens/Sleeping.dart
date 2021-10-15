import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'dart:async';

class Sleeping extends StatefulWidget {

  final String baby;

  const Sleeping({Key? key, required this.baby}) : super(key: key);
  @override
  _SleepingState createState() => _SleepingState();
}

class _SleepingState extends State<Sleeping> {

  @override
  Widget build(BuildContext context) {

    String babyPath = widget.baby;

    // appBar header
    return Scaffold(
        backgroundColor: Colors.white38,
        appBar: AppBar(
          title: Text('Sleeping'),
          centerTitle: true,
          backgroundColor: Colors.yellow,
          actions: [
            Icon(Icons.more_vert),
          ],
        ),
        body: const SleepingForm(),
    );
  }
}

class SleepingForm extends StatefulWidget {
  const SleepingForm({Key? key}) : super(key: key);

  @override
  SleepingFormState createState() {
    return SleepingFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class SleepingFormState extends State<SleepingForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  String? _selectedTime1;
  String? _selectedTime2;
  int start = 0;
  int stop = 0;
  String notes = 'note';

  Future<void> _test1() async {
    final TimeOfDay? result = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if(result != null){
      setState(() {
        _selectedTime1 = result.format(context);
      }
      );
      print(result.period); // DayPeriod.pm or DayPeriod.am
      print(result.hour);
      start = result.hour;
      print(result.minute);
    }
  }
  Future<void> _show1() async {
    final TimeOfDay? result =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        _selectedTime1 = result.format(context);
      });
    }
  }
  Future<void> _show2() async {
    final TimeOfDay? result =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        _selectedTime2 = result.format(context);
      });
      stop = result.hour;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  FirestoreDatabase().addSleepTime(start, stop, notes);
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
        ],
      ),
    );
  }
}