import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/models/sleepingChartData.dart';

class SleepingGraphs extends StatefulWidget {

  final String baby;

  const SleepingGraphs({Key? key, required this.baby}) : super(key: key);
  @override
  _SleepingGraphsState createState() => _SleepingGraphsState();
}

class _SleepingGraphsState extends State<SleepingGraphs> {
  var list1 = List<double>.filled(7,1.0);

  Future<void> generate() async{
    setState(() {
      list1[0] = dayArr[0];
      list1[1] = dayArr[1];
      list1[2] = dayArr[2];
      list1[3] = dayArr[3];
      list1[4] = dayArr[4];
      list1[5] = dayArr[5];
      list1[6] = dayArr[6];
    });
  }

  @override
  Widget build(BuildContext context) {
    Query sleepRef = FirebaseFirestore.instance.doc(widget.baby).collection('sleeping').orderBy("indexDate", descending: true);
    String babyPath = widget.baby;

    return ListView(
        children: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(10),
            color: Colors.blue,
            height: 200,
            child: BarChart(
              BarChartData (
                maxY: 25,
                barGroups: [BarChartGroupData(x: 1, barRods: [BarChartRodData(y: list1[0])]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(y: list1[1])]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(y: list1[2])]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(y: list1[3])]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(y: list1[4])]),
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(y: list1[5])]),
                  BarChartGroupData(x: 7, barRods: [BarChartRodData(y: list1[6])]),],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: ElevatedButton.icon(
              onPressed: () => generate(),
              label: Text(''),
              icon: Icon(
                Icons.check,
              ),
            ),
          ),
        ),],
    );
  }

  Widget _daySeven() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.blue,
        height: 200,
        child: BarChart(
          BarChartData (
            maxY: 20,
            barGroups: [BarChartGroupData(x: 1, barRods: [BarChartRodData(y: list1[0])]),
              BarChartGroupData(x: 2, barRods: [BarChartRodData(y: list1[1])]),
              BarChartGroupData(x: 3, barRods: [BarChartRodData(y: list1[2])]),
              BarChartGroupData(x: 4, barRods: [BarChartRodData(y: list1[3])]),
              BarChartGroupData(x: 5, barRods: [BarChartRodData(y: list1[4])]),
              BarChartGroupData(x: 6, barRods: [BarChartRodData(y: list1[5])]),
              BarChartGroupData(x: 7, barRods: [BarChartRodData(y: list1[6])]),],
          ),
        ),
      ),
    );
  }
}