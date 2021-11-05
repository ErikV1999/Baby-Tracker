import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:baby_tracker/screens/SleepingStats.dart';

class SleepingGraphs extends StatefulWidget {

  @override
  _SleepingGraphsState createState() => _SleepingGraphsState();
}

class _SleepingGraphsState extends State<SleepingGraphs> {


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

  Widget _daySeven() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        maxY: 20,
        minY: 0,
        groupsSpace: 12,
      ),
    );
  }
}