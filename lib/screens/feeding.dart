import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'dart:async';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/cupertino.dart';

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
  Color orangeYellow = Color(0xFFFED766);
  Color blueSapphire = Color(0xFF006992);


  bool leftIsPress = true;
  bool rightIsPress = false;
  bool bottleIsPress = false;
  bool foodIsPress = false;

  bool startIsPress = false;
  bool stopIsPress = true;
  bool resetIsPress = true;

  String timetodisplay = "00:00:00";
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  String? timeString;

  int month = DateTime.now().month;
  int day = DateTime.now().day;
  int year = DateTime.now().year;
  int startHour = TimeOfDay.now().hour;
  int startMin = TimeOfDay.now().minute;
  int stopHour = 0;
  int stopMin = 0;
  int stopSec = 0;
  int totalFeed = 0;

  var notes = 'note';
  String amount = 'amount';

  DateTime? _chosenDateTime;
  Duration duration = Duration(); //set duration to zero in other functions
  final _isHours = true;

  //set StopWatchTimer mode to count up
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChange: (value) {
      final displayTime = StopWatchTimer.getDisplayTime(value);
      print('displayTime $displayTime');
    },
    onChangeRawSecond: (value) =>
        print('onChangeRawSecond $value'), //can comment out if needed
    onChangeRawMinute: (value) =>
        print('onChangeRawMinute $value'), //can comment out if needed
  );

  //stop watch constructor
  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
  }

  //stopwatch destructor
  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  void turnStopWatchOn() {
    setState(() {
      startIsPress = false;
      stopIsPress = false;
      resetIsPress = false;
    });
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
  }

  void turnStopWatchOff() {
    setState(() {
      startIsPress = true;
      stopIsPress = true;
      resetIsPress = true;
    });
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
  }

  void leftBreastButton() {
    setState(() {
      leftIsPress = true;
      rightIsPress = false;
      bottleIsPress = false;
      foodIsPress = false;

      turnStopWatchOn();
    });
  }

  void rightBreastButton() {
    setState(() {
      leftIsPress = false;
      rightIsPress = true;
      bottleIsPress = false;
      foodIsPress = false;

      turnStopWatchOn();
    });
  }

  void bottleButton() {
    setState(() {
      leftIsPress = false;
      rightIsPress = false;
      bottleIsPress = true;
      foodIsPress = false;

      turnStopWatchOff();
    });
  }

  void foodButton() {
    setState(() {
      leftIsPress = false;
      rightIsPress = false;
      bottleIsPress = false;
      foodIsPress = true;

      turnStopWatchOff();
    });
  }

  //start of stopwatch
  void startStopwatch() {
    setState(() {
      startIsPress = true;
      stopIsPress = false;
      resetIsPress = true;
    });
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  //stop stopwatch
  void stopStopwatch() {
    setState(() {
      startIsPress = false;
      stopIsPress = true;
      resetIsPress = false;
    });
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
  }

  //reset time to zero 00:00:00
  void resetStopwatch() {
    setState(() {
      startIsPress = false;
      stopIsPress = true;
      resetIsPress = true;
    });
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
  }

  void _pickStartDate() async {
    final DateTime? dateResult = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: _startDate,
    );
    if (dateResult != null)
      setState(() {
        _startDate = dateResult;
        year = dateResult.year;
        month = dateResult.month;
        day = dateResult.day;
        print("year: $year");
        print("month: $month");
        print("day: $day");
      });
  }

  void _pickEndTime(ctx) async {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 400,
                    child: CupertinoTimerPicker(
                      initialTimerDuration: duration,
                      mode: CupertinoTimerPickerMode.hms,
                      onTimerDurationChanged: (duration) => setState(() {
                        _stopWatchTimer.setPresetSecondTime(1);
                      }),
                    ),
                  ),
                  // Close the modal
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            ));
  }

  void _pickStartTime() async {
    final TimeOfDay? timeResult =
        await showTimePicker(context: context, initialTime: _startTime);
    if (timeResult != null) {
      setState(() {
        _startTime = timeResult;
        timeString = timeResult.format(context);
      });
      print(timeResult.period); // DayPeriod.pm or DayPeriod.am
      print(timeResult.hour);
      print(timeResult.minute);
      timetodisplay = "$timeResult.hour";
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String babyPath = widget.baby;
    String path = babyPath.substring(42);
    print(babyPath);
    print(path);

    //print("$month / $day / $year");
    //print("$startHour : $startMin ");

    /*
    * APP BAR Header
    * */
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        title: Text(
          'Sleeping',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: orangeYellow,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            /*
              * date container to show date and change date
              * */
            _buildDate(),
            /*
              * button container to show and click on buttons
              * */
            _buildButtons(),
            /*
              * time container to show the timers time
              * */
            _buildTimer(),
            /*
              * button container to show and click buttons for the timer
              * */
            _buildTimerButtons(),
            /*
              * amount container to edit notes
              * */
            _buildAmount(),
            /*
              * note container to edit notes
              * */
            _buildNotes(),
            /*
              * button container to submit data to firebase
              * */
            Container(
              width: 500,
              height: 100,
              color: Colors.white,
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
                      "${_startDate.year}/${_startDate.month}/${_startDate.day}",
                      timetodisplay,
                      notes,
                      babyPath);
                  FirestoreDatabase().updateLastFeed(
                      "${_startDate.year}/${_startDate.month}/${_startDate.day}",
                      babyPath);
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDate() {
    return Container(
      alignment: Alignment.centerLeft,
      width: 250,
      height: 75,
      padding: EdgeInsets.all(1.0),
      color: Colors.white,
      child: ListTile(
        title: Text(
            "Date: ${_startDate.year}/${_startDate.month}/${_startDate.day}",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        trailing: Icon(Icons.keyboard_arrow_down),
        onTap: _pickStartDate,
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      color: Colors.white,
      height: 100,
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
                  primary: blueSapphire,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 25.0,
                  ),
                ), //styleFrom
                onPressed: leftBreastButton, //activates stopwatch buttons
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
                  primary: blueSapphire,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 25.0,
                  ),
                ), //styleFrom
                onPressed: rightBreastButton, //activates stopwatch buttons
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
                  primary: blueSapphire,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 25.0,
                  ),
                ), //styleFrom
                onPressed: bottleButton, //deactivates stopwatch buttons
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
                  primary: blueSapphire,
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
    );
  }

  Widget _buildTimer() {
    return Container(
      height: 100,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StreamBuilder<int>(
                stream: _stopWatchTimer.rawTime,
                initialData: _stopWatchTimer.rawTime.value,
                builder: (context, snap) {
                  final value = snap.data!;
                  final displayTime =
                      StopWatchTimer.getDisplayTime(value, hours: _isHours);
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          displayTime,
                          style: const TextStyle(
                              fontSize: 40,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
      ),
    );
  }

  Widget _buildTimerButtons() {
    return Container(
      height: 75,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
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
                  primary: Colors.lightBlueAccent,
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
    );
  }

  Widget _buildAmount() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          // The validator receives the text that the user has entered.
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Amount',
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 4.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow, width: 4.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an Amount';
            }
            amount = value;
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildNotes() {
    return Container(
      color: Colors.white,
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
                borderSide: BorderSide(color: Colors.white, width: 4.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow, width: 4.0)),
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
    );
  }

}
