import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:baby_tracker/models/diaperchangechart.dart';

class diaperstats extends StatefulWidget {

  @override
  _diaperstats createState() => _diaperstats();
}

class _diaperstats extends State<diaperstats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("Graph"),
      backgroundColor: Colors.cyanAccent,
    ),
  body: ListView(
    padding: const EdgeInsets.all(8),
    children: <Widget>[
      Container(
        padding: const EdgeInsets.all(10),
        height: 450,
        color: Colors.blue,
        child: LineChart(
          LineChartData(
            backgroundColor: Colors.white,
            minX: 0,
            maxX: 10,
            minY: 0,
            maxY: 6,
            gridData: FlGridData(
              show: false,
            ),
            borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.blueAccent, width: 1),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots3,
                isCurved: false,
                barWidth: 20,
                belowBarData: BarAreaData(
                show: false,
                )
              )
            ]
          ),
        ),
      )
    ],
  ),
    );
  }
}
List<List<double>> data = [
  [1, 2],
  [2, 2],
  [3, 1],
  [4, 5],
];
final spots3 = <FlSpot>[
  for(int i = 0; i < data.length; i++)
    FlSpot(data[i][0], data[i][1])

];
