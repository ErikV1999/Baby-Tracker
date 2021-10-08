import 'package:flutter/material.dart';
import 'dart:async';

class Sleeping extends StatefulWidget {
  const Sleeping({Key? key}) : super(key: key);
  @override
  _SleepingState createState() => _SleepingState();
}

class _SleepingState extends State<Sleeping> {
  Duration duration = Duration();
  Timer? timer;

  bool isCountdown = false;

  @override
  void initState() {
    super.initState();

    reset();
  }

  //reset timer
  void reset() {
    setState(() => duration = Duration());
  }

  // add to timer, in 1 second
  void addTime() {
    final addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  // start the timer
  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    timer = Timer.periodic(Duration(seconds:1), (_) => addTime());
  }

  // stop/pause the timer
  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) {
    // appBar header
    return Scaffold(
        backgroundColor: Colors.white38,
        appBar: AppBar(
          title: Text('Sleeping'),
          centerTitle: true,
          backgroundColor: Colors.amber,
          actions: [
            Icon(Icons.more_vert),
          ],
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTime(),
                const SizedBox(height: 80),
                buildButtons(),
              ]
            ),
        )
    );
  }

  // Start, Stop, and cancel buttons
  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;

    // when counter stop and cancel are displayed
    if (isRunning) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                if (isRunning) {
                  stopTimer(resets: false);
                } else {
                  startTimer(resets: false);
                }
              },
              child: (
                  const Text('STOP')
              ) ,
          ),
          const SizedBox(width: 12),
          ElevatedButton(
              onPressed: () {stopTimer();},
              child: (
                  const Text('CANCEL')
              ),
          ),
        ]
    );
    } // when stopped/paused resume and cancel
     else if (!isCompleted) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (isRunning) {
                  stopTimer(resets: false);
                } else {
                  startTimer(resets: false);
                }
              },
              child: (
                  const Text('RESUME')
              ) ,
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {stopTimer();},
              child: (
                  const Text('CANCEL')
              ),
            ),
          ]
      );
    } // beginning timer/ has been reset
      else {
      return ElevatedButton(
      child: (
          const Text('Baby Sleeping!')
      ),
      onPressed: () {
        startTimer();
      },

    );
    }
  }

  //here the hours/minutes/seconds are built
  //we can extract these values to save on the database
  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTimeCard(time: hours, header: 'HOURS'),
          const SizedBox(width: 8),
          buildTimeCard(time: minutes, header: 'MINUTES'),
          const SizedBox(width: 8),
          buildTimeCard(time: seconds, header: 'SECONDS'),
        ],
    );
  }

  //visualize the hours/minutes/seconds
  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 72,
              ),
            ),
          ),
          const SizedBox(height:24),
          Text(header),
        ],
      );


}