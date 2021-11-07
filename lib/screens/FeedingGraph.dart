import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:baby_tracker/screens/FeedingStats.dart';

class FeedingGraphs extends StatefulWidget {
  @override
  _FeedingGraphsState createState() => _FeedingGraphsState();
}

class _FeedingGraphsState extends State<FeedingGraphs> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          height: 550,
          color: Colors.blue,
        ),
      ],
    );
  }
}
