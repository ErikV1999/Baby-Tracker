import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:baby_tracker/models/chartContainer.dart';
import 'package:baby_tracker/models/barChart.dart';
import 'package:baby_tracker/models/sleepingChartData.dart';

class debugPage extends StatefulWidget {
  final String baby;

  const debugPage({Key? key, required this.baby}) : super(key: key);

  @override
  _debugPageState createState() => _debugPageState();
}

class _debugPageState extends State<debugPage> {

  @override
  Widget build(BuildContext context) {
    String babyPath = widget.baby;
    return Scaffold(
      appBar: AppBar(
        title: Text('debug'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.blue,
        height: 200,
        child: BarChart(
          BarChartData (
            maxY: 20,
            barGroups: [BarChartGroupData(x: 1, barRods: [BarChartRodData(y: 10)])],
          ),
        ),
        ),
      ),
    );
  }
}