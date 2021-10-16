import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'dart:async';

class Feeding extends StatefulWidget {
  final String baby;

  const Feeding({Key? key, required this.baby}) : super(key: key);
  @override
  _FeedingState createState() => _FeedingState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class _FeedingState extends State<Feeding> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.

  bool leftIsPress = true;
  bool rightIsPress = false;
  bool bottleIsPress = false;
  bool foodIsPress = false;

  bool startIsPress = false;
  bool stopIsPress = true;
  bool resetIsPress = true;

  String notes = 'note';

  String timetodisplay = "00:00:00";
  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);
  DateTime pickedDate = DateTime.now();

  void leftBreastButton() {
    setState(() {
      leftIsPress = true;
      rightIsPress = false;
      bottleIsPress = false;
      foodIsPress = false;

      startIsPress = false;
      stopIsPress = false;
      resetIsPress = false;
    });
  }

  void rightBreastButton() {
    setState(() {
      leftIsPress = false;
      rightIsPress = true;
      bottleIsPress = false;
      foodIsPress = false;

      startIsPress = false;
      stopIsPress = false;
      resetIsPress = false;
    });
  }

  void bottleButton() {
    setState(() {
      leftIsPress = false;
      rightIsPress = false;
      bottleIsPress = true;
      foodIsPress = false;

      startIsPress = true;
      stopIsPress = true;
      resetIsPress = true;
    });
    swatch.stop();
    swatch.reset();
    timetodisplay = "00:00:00";
  }

  void foodButton() {
    setState(() {
      leftIsPress = false;
      rightIsPress = false;
      bottleIsPress = false;
      foodIsPress = true;

      startIsPress = true;
      stopIsPress = true;
      resetIsPress = true;
    });
    swatch.stop();
    swatch.reset();
    timetodisplay = "00:00:00";
  }

  //start feeding time
  void startTimer() {
    startIsPress = true;
    stopIsPress = false;
    resetIsPress = true;
    Timer(dur, keepRunning);
  }

  //keep feeding timer running
  void keepRunning() {
    if (swatch.isRunning) {
      startTimer();
    }
    setState(() {
      timetodisplay = swatch.elapsed.inHours.toString().padLeft(2, "0") +
          ":" +
          (swatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
          ":" +
          (swatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    });
  }

  //start of Left breast stopwatch
  void startStopwatch() {
    setState(() {
      startIsPress = true;
      stopIsPress = false;
      resetIsPress = true;
    });
    swatch.start();
    startTimer();
  }

  //stop time
  void stopStopwatch() {
    setState(() {
      startIsPress = false;
      stopIsPress = true;
      resetIsPress = false;
    });
    swatch.stop();
  }

  //reset time to zero 00:00:00
  void resetStopwatch() {
    setState(() {
      startIsPress = false;
      stopIsPress = true;
      resetIsPress = true;
    });
    swatch.stop();
    swatch.reset();
    timetodisplay = "00:00:00";
  }

  void _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
    );
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String babyPath = widget.baby;
    String path = babyPath.substring(42);
    print(babyPath);
    print(path);

    /*
    * APP BAR Header
    * */
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        title: Text('Feeding'),
        centerTitle: true,
        backgroundColor: Colors.cyanAccent,
        actions: [
          Icon(Icons.more_vert_outlined),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /*
              *
              * date container to show date and change date
              *
              * */
            Expanded(
              flex: 0,
              child: Container(
                alignment: Alignment.centerLeft,
                width: 250,
                height: 50,
                padding: EdgeInsets.all(1.0),
                color: Colors.purpleAccent,
                child: ListTile(
                  title: Text(
                      "Date: ${pickedDate.year}/${pickedDate.month}/${pickedDate.day}",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w400)),
                  trailing: Icon(Icons.keyboard_arrow_down),
                  onTap: _pickDate,
                ),
              ),
            ),
            /*
              *
              * button container to show and click on buttons
              *
              * */
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.greenAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    /*
                    * row of buttons
                    * */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        /*
                        * Left breast button
                        * */
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 25.0,
                            ),
                          ), //styleFrom
                          onPressed:
                              leftBreastButton, //activates stopwatch buttons
                          child: Text(
                            "LB",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        /*
                        * Right Breast Button
                        * */
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 25.0,
                            ),
                          ), //styleFrom
                          onPressed:
                              rightBreastButton, //activates stopwatch buttons
                          child: Text(
                            "RB",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        /*
                        * Bottle Button
                        * */
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 25.0,
                            ),
                          ), //styleFrom
                          onPressed:
                              bottleButton, //deactivates stopwatch buttons
                          child: Text(
                            "Bottle",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        /*
                        * Food Button
                        * */
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 25.0,
                            ),
                          ), //styleFrom
                          onPressed: foodButton, //deactivates stopwatch buttons
                          child: Text(
                            "Food",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                padding: EdgeInsets.all(30.0),
                color: Colors.cyan,
                alignment: Alignment.center,
                child: Text(
                  timetodisplay,
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.pinkAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orangeAccent,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 15.0,
                            ),
                          ), //styleFrom
                          onPressed: startIsPress ? null : startStopwatch,
                          child: Text(
                            "Start",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 15.0,
                            ),
                          ), //styleFrom
                          onPressed: stopIsPress ? null : stopStopwatch,
                          child: Text(
                            "Stop",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 15.0,
                            ),
                          ), //styleFrom
                          onPressed: resetIsPress ? null : resetStopwatch,
                          child: Text(
                            "Reset",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.blueGrey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // The validator receives the text that the user has entered.
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Notes',
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 4.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.yellow, width: 4.0)),
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
            ),
            Container(
              width: 500,
              height: 100,
              color: Colors.lime,
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrangeAccent,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 15.0,
                  ),
                ),
                onPressed: () {
                  FirestoreDatabase().addFeeding(
                      "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}",
                      timetodisplay,
                      notes,
                      path);
                  FirestoreDatabase().updateLastFeed(
                      "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}",
                      path);
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
