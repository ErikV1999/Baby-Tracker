import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/AllStats.dart';

class SleepingStats extends StatefulWidget {

  @override
  _SleepingStatsState createState() => _SleepingStatsState();
}

class _SleepingStatsState extends State<SleepingStats> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange,
        child: Center(
          child: Text(
            'Sleeping Stats',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}