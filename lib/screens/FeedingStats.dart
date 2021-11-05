import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/AllStats.dart';

class FeedingStats extends StatefulWidget {

  @override
  _FeedingStatsState  createState() => _FeedingStatsState();
}

class _FeedingStatsState extends State<FeedingStats> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.greenAccent,
        child: Center(
          child: Text(
            'Feeding Stats',
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