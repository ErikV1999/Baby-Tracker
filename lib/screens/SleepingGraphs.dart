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
  var listy = List<double>.filled(7,1.0);
  var listx = List<String>.filled(7,'A');

  Future<void> generate() async{
    setState(() {
      listy[0] = dayArr[0];
      listy[1] = dayArr[1];
      listy[2] = dayArr[2];
      listy[3] = dayArr[3];
      listy[4] = dayArr[4];
      listy[5] = dayArr[5];
      listy[6] = dayArr[6];
      listx[0] = dayArr2[0];
      listx[1] = dayArr2[1];
      listx[2] = dayArr2[2];
      listx[3] = dayArr2[3];
      listx[4] = dayArr2[4];
      listx[5] = dayArr2[5];
      listx[6] = dayArr2[6];
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
                titlesData: FlTitlesData(
                bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 6,
                  getTitles: (value) {
                  switch (value.toInt()) {
                    case 0:
                      return listx[0];
                    case 1:
                      return listx[1];
                    case 2:
                      return listx[2];
                    case 3:
                      return listx[3];
                    case 4:
                      return listx[4];
                    case 5:
                      return listx[5];
                    case 6:
                      return listx[6];
                    default:
                      return '';
                  }
                  }
                  ),
                  topTitles: SideTitles(
                    showTitles: false,
                  ),
                  rightTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                barGroups: [BarChartGroupData(x: 0, barRods: [BarChartRodData(y: listy[0])]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(y: listy[1])]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(y: listy[2])]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(y: listy[3])]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(y: listy[4])]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(y: listy[5])]),
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(y: listy[6])]),],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: ElevatedButton.icon(
              onPressed: () => generate(),
              label: Text('Generate 7 Day Graph'),
              icon: Icon(
                Icons.check,
              ),
            ),
          ),
        ),],
    );
  }
}