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

  late final String title;
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

  Widget build(BuildContext context) {
    const cutOffYValue = 0.0;
    const yearTextStyle =
    TextStyle(
        fontSize: 10,
        color: Colors.black,
        fontWeight: FontWeight.bold
    );
    return Scaffold(
      appBar: AppBar(),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0.0),
        child: Container(
          width: 330,
          height: 180,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 0),
                    FlSpot(1, 1),
                    FlSpot(2, 3),
                    FlSpot(3, 3),
                    FlSpot(4, 5),
                    FlSpot(4, 4)
                  ],
                  isCurved: false,
                  barWidth: 1,
                  colors: [
                    Colors.black,
                  ],
                  belowBarData: BarAreaData(
                    show: true,
                    colors: [Colors.orange.withOpacity(0.4)],
                    cutOffY: cutOffYValue,
                    applyCutOffY: true,
                  ),
                  aboveBarData: BarAreaData(
                    show: true,
                    colors: [Colors.red.withOpacity(0.6)],
                    cutOffY: cutOffYValue,
                    applyCutOffY: true,
                  ),
                  dotData: FlDotData(
                    show: false,
                  ),
                ),
              ],
              minY: 0,
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 6,
                    getTitles: (value) {
                      switch (value.toInt()) {
                        case 0:
                          return '2017';
                        case 1:
                          return '2018';
                        case 2:
                          return '2019';
                        case 3:
                          return '2020';
                        case 4:
                          return '2021';
                        default:
                          return '';
                      }
                    }),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTitles: (value) {
                    return '\$ ${value + 20}';
                  },
                ),
              ),
              axisTitleData: FlAxisTitleData(
                  leftTitle: AxisTitle(showTitle: true, titleText: 'Value', margin: 10),
                  bottomTitle: AxisTitle(
                      showTitle: true,
                      margin: 10,
                      titleText: 'Year',
                      textStyle: yearTextStyle,
                      textAlign: TextAlign.right)),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (double value) {
                  return value == 1 || value == 2 || value == 3 || value == 4;
                },
              ),
            ),
          ),
        ),
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