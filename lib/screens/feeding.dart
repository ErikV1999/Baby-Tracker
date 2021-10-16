import 'package:flutter/material.dart';
import 'dart:async';

class Feeding extends StatefulWidget {

  final String baby;
  const Feeding({Key? key, required this.baby}) : super(key: key);

  @override
  _FeedingState createState() => _FeedingState();
}

class _FeedingState extends State<Feeding> {

  bool leftispress = true;
  bool rightispress = true;
  bool stopispress = true;
  bool resetispress = true;
  String timetodisplay = "00:00:00";
  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);

  //start feeding time
  void startTimer(){
    Timer(dur, keeprunning);
  }

  //keep feeding timer running
  void keeprunning(){
    if(swatch.isRunning){
      startTimer();
    }
    setState(() {
      timetodisplay = swatch.elapsed.inHours.toString().padLeft(2, "0") + ":" + (swatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") + ":" + (swatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    });
  }

  //start of Left breast stopwatch
  void startLeftStopwatch(){
    setState(() {
      stopispress = false;
      leftispress = false;
      rightispress = false;
      //if statement to fix reset
    });
    swatch.start();
    startTimer();
  }

  //start of Right breast stopwatch
  void startRightStopwatch(){
    setState(() {
      stopispress = false;
      leftispress = false;
      rightispress = false;
      //if statement to fix reset
    });
    swatch.start();
    startTimer();
  }

  //stop time
  void stopStopwatch(){
    setState(() {
      stopispress = true;
      resetispress = false;
      leftispress = true;
      rightispress = true;
    });
    swatch.stop();

  }

  //reset time to zero 00:00:00
  void resetStopwatch(){
    setState(() {
      leftispress = true;
      rightispress = true;
      resetispress = true;
    });
    swatch.reset();
    timetodisplay = "00:00:00";
  }

  @override
  Widget build(BuildContext context) {

    String babyPath = widget.baby;

    // appBar header
    return Scaffold(
        backgroundColor: Colors.white60,
        appBar: AppBar(
          title: Text('Feeding'),
          centerTitle: true,
          backgroundColor: Colors.amber,
          actions: [
            Icon(Icons.more_vert_outlined),
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Container(
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
                flex: 4,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              onPrimary: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 40.0,
                                vertical: 15.0,
                              ),
                            ), //styleFrom
                              onPressed: stopispress ? null : stopStopwatch,
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
                            onPressed: resetispress ? null : resetStopwatch,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 25.0,
                          ),
                        ), //styleFrom
                        onPressed: leftispress ? startLeftStopwatch : null,
                          child: Text(
                            "Left Start",
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                              ),
                            ),
                          ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 25.0,
                          ),
                        ), //styleFrom
                        onPressed: rightispress ? startRightStopwatch: null,
                        child: Text(
                          "Right Start",
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }
}