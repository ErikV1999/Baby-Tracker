import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

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

  bool leftBreast = true; //
  bool rightBreast = false; //
  bool bottle = false; //
  bool food = false; //

  String feedingType = 'Left Breast';

  bool startIsPress = false;
  bool stopIsPress = true;
  bool resetIsPress = true;

  String Date1 = '';
  String Date2 = '';
  String Date3 = '';
  String conDate = '';
  int indexDate = 0;
  String timetodisplay = "00:00:00";
  DateTime _startDate = DateTime.now();
  DateFormat formatter = DateFormat('MM-dd-yyyy');
  String _dateString = ' ';
  String? timeString;

  int month = DateTime.now().month;
  int day = DateTime.now().day;
  int year = DateTime.now().year;
  int totalTimeSec = 0; //

  String notes = 'note';
  String amount = 'amount';
  String foodType = 'food';

  var fieldTextFood = TextEditingController();
  var fieldTextAmount = TextEditingController();
  var fieldTextNotes = TextEditingController();

  Duration duration = Duration(); //set duration to zero in other functions
  final _isHours = true;

  //set StopWatchTimer mode to count up
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    //onChange: (value) {
    //final displayTime = StopWatchTimer.getDisplayTime(value);
    //print('displayTime $displayTime');
    //}
  );

  //stop watch constructor
  @override
  void initState() {
    super.initState();
  }

  //stopwatch destructor
  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  void clearText() {
    fieldTextFood.clear();
    fieldTextAmount.clear();
    fieldTextNotes.clear();
  }

  void turnStopWatchOn() {
    setState(() {
      startIsPress = false;
      stopIsPress = true;
      resetIsPress = true;
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
      leftBreast = true;
      rightBreast = false;
      bottle = false;
      food = false;
      feedingType = 'Left Breast';

      clearText();
      turnStopWatchOn();
    });
  }

  void rightBreastButton() {
    setState(() {
      leftBreast = false;
      rightBreast = true;
      bottle = false;
      food = false;
      feedingType = 'Right Breast';

      clearText();
      turnStopWatchOn();
    });
  }

  void bottleButton() {
    setState(() {
      leftBreast = false;
      rightBreast = false;
      bottle = true;
      food = false;
      feedingType = 'Bottle';

      clearText();
      turnStopWatchOff();
    });
  }

  void foodButton() {
    setState(() {
      leftBreast = false;
      rightBreast = false;
      bottle = false;
      food = true;
      feedingType = 'Food';

      clearText();
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
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      initialDate: _startDate,
    );
    if (dateResult != null)
      setState(() {
        _startDate = dateResult;
        year = dateResult.year;
        month = dateResult.month;
        day = dateResult.day;
        _dateString = formatter.format(_startDate);
        print(_dateString);
        print(_dateString.substring(3, 5));
        Date1 = _dateString.toString().substring(0, 2);
        Date2 = _dateString.toString().substring(3, 5);
        Date3 = _dateString.toString().substring(6, 10);
        conDate = Date3 + Date1 + Date2;
        print(conDate);
        indexDate = int.parse(conDate);
        print(indexDate);
        //print("year: $year");
        //print("month: $month");
        //print("day: $day");
      });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String babyPath = widget.baby;
    String path = babyPath.substring(42);
    setState(() {
      _dateString = formatter.format(_startDate);
      print(_dateString);
      print(_dateString.substring(3, 5));
      Date1 = _dateString.toString().substring(0, 2);
      Date2 = _dateString.toString().substring(3, 5);
      Date3 = _dateString.toString().substring(6, 10);
      conDate = Date3 + Date1 + Date2;
      print(conDate);
      indexDate = int.parse(conDate);
      print(indexDate);
    });

    /*
    * APP BAR Header
    * */
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feeding',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _buildDate(),
            _buildButtons(),
            if (leftBreast == true) _buildTimer(),
            if (leftBreast == true) _buildTimerButtons(),
            if (rightBreast == true) _buildTimer(),
            if (rightBreast == true) _buildTimerButtons(),
            if (bottle == true) _buildAmount(),
            if (food == true) _buildFoodType(),
            if (food == true) _buildAmount(),
            _buildNotes(),
            /*
              * button container to submit data to firebase
              * */
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: blueSapphire,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 15.0,
                  ),
                ),
                onPressed: () {
                  stopStopwatch();
                  totalTimeSec = _stopWatchTimer.secondTime.value;
                  print(leftBreast);
                  print(food);
                  print(month);
                  print(day);
                  print(year);
                  print(totalTimeSec);
                  if (fieldTextFood.text.isEmpty) foodType = 'food';
                  if (fieldTextFood.text.isNotEmpty)
                    setState(() => foodType = fieldTextFood.text);

                  if (fieldTextAmount.text.isEmpty) amount = '0';
                  if (fieldTextAmount.text.isNotEmpty)
                    setState(() => amount = fieldTextAmount.text);

                  if (fieldTextNotes.text.isEmpty) notes = 'none';
                  if (fieldTextNotes.text.isNotEmpty)
                    setState(() => notes = fieldTextNotes.text);
                  FirestoreDatabase().addFeeding(
                      feedingType,
                      _dateString,
                      indexDate,
                      totalTimeSec,
                      foodType,
                      amount,
                      notes,
                      babyPath);
                  //FirestoreDatabase().updateLastFeed(
                      //"${_startDate.year}/${_startDate.month}/${_startDate.day}",
                      //_startDate,
                      //babyPath);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
              * date container to show date and change date
              * */
  Widget _buildDate() {
    return Container(
      alignment: Alignment.centerLeft,
      width: 250,
      height: 75,
      padding: EdgeInsets.all(1.0),
      child: ListTile(
        title: Text(
            "Date: ${_startDate.month}/${_startDate.day}/${_startDate.year}",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          size: 30,
        ),
        onTap: _pickStartDate,
      ),
    );
  }

  /*
              * button container to show and click on buttons
              * */
  Widget _buildButtons() {
    return Container(
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
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*
              * time container to show the timers time
              * */
  Widget _buildTimer() {
    return Container(
      height: 100,
      //color: Colors.white,
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

  /*
              * button timer container to control timer
              * */
  Widget _buildTimerButtons() {
    return Container(
      height: 75,
      //color: Colors.white,
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
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*
              * food enter container to edit food type
              * */
  Widget _buildFoodType() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Enter Food',
            focusColor: Colors.black,
          ),
          controller: fieldTextFood,
        ),
      ),
    );
  }

  Widget _buildAmount() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Amount',
            focusColor: Colors.black,
          ),
          controller: fieldTextAmount,
        ),
      ),
    );
  }

  Widget _buildNotes() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Notes',
            focusColor: Colors.black,
          ),
          controller: fieldTextNotes,
        ),
      ),
    );
  }
}
