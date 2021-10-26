import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';

class graphDisplay extends StatefulWidget {

  final String baby;

  const graphDisplay({Key? key, required this.baby}) : super(key: key);
  @override
  _graphDisplayState createState() => _graphDisplayState();
}

class _graphDisplayState extends State<graphDisplay> {
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
            height: 550,
            color: Colors.blue,
            child: LineChart(
              LineChartData(
                backgroundColor: Colors.white,
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 6,
                  gridData: FlGridData(
                    show: true,

                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.blueAccent, width: 1),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0,3),
                        FlSpot(2,2),
                        FlSpot(5,5),
                        FlSpot(7,3),
                        FlSpot(8,4),
                      ],
                      isCurved: true,
                      barWidth: 7,
                      belowBarData: BarAreaData(
                        show: true,
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
