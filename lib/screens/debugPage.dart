import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/models/sleepingChartData.dart';

class debugPage extends StatefulWidget {
  final String baby;

  const debugPage({Key? key, required this.baby}) : super(key: key);

  @override
  _debugPageState createState() => _debugPageState();
}

class _debugPageState extends State<debugPage> {
  dynamic baby = "Placeholder";
  var list1 = List<double>.filled(7,1.0);

  Future<void> generate() async{
    setState(() {
      //print(snapshot);
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
    String babyPath = widget.baby;
    Query sleepRef = FirebaseFirestore.instance.doc(widget.baby).collection('sleeping').orderBy("indexDate", descending: true);

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
              barGroups: [
                BarChartGroupData(x: 1, barRods: [
                  BarChartRodData(y: list1[0], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
                ]),
                BarChartGroupData(x: 2, barRods: [
                  BarChartRodData(y: list1[1], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
                ]),
                BarChartGroupData(x: 3, barRods: [
                  BarChartRodData(y: list1[2], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
                ]),
                BarChartGroupData(x: 4, barRods: [
                  BarChartRodData(y: list1[3], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
                ]),
                BarChartGroupData(x: 5, barRods: [
                  BarChartRodData(y: list1[4], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
                ]),
                BarChartGroupData(x: 6, barRods: [
                  BarChartRodData(y: list1[5], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
                ]),
                BarChartGroupData(x: 7, barRods: [
                  BarChartRodData(y: list1[6], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
                ]),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          generate();
        },
        child: const Icon(Icons.check),
      ),

    );
  }
}

/*return Scaffold(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          generate();
        },
        child: const Icon(Icons.check),
      ),

    );

 */