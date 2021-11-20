import 'package:baby_tracker/models/Themes/theme_provider.dart';
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
  bool show7Day = true;
  bool show5Month = false;

  var listy = List<double>.filled(7,0.0);
  var listx = List<String>.filled(7,'-');

  var monthY = List<double>.filled(5,0.0);
  var monthX = List<String>.filled(5,'-');

  List<Color> barColor = [Colors.green, Colors.red];

  void initState() {
    super.initState();
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

  Future<void> generate7() async{
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

  Future<void> generate5() async{
    setState(() {
      monthY[0] = monthArr[0];
      monthY[1] = monthArr[1];
      monthY[2] = monthArr[2];
      monthY[3] = monthArr[3];
      monthY[4] = monthArr[4];
      monthX[0] = monthArr2[0];
      monthX[1] = monthArr2[1];
      monthX[2] = monthArr2[2];
      monthX[3] = monthArr2[3];
      monthX[4] = monthArr2[4];
    });
  }

  @override
  Widget build(BuildContext context) {
    Query sleepRef = FirebaseFirestore.instance.doc(widget.baby).collection('sleeping').orderBy("indexDate", descending: true);
    String babyPath = widget.baby;

    return ListView(
        children: [
          if (show7Day == true) _build7DayTitle(),
          if (show7Day == true) _build7Day(),
          if (show5Month == true) _build5MonthTitle(),
          if (show5Month == true) _build5Month(),
          SizedBox(height: 25.0,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ElevatedButton.icon(
                onPressed: () => {
                  generate7(),
                  show7Day = true,
                  show5Month = false,
                },
                label: Text('Generate 7 Day Graph'),
                icon: Icon(
                  Icons.check,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ElevatedButton.icon(
                onPressed: () => {
                  generate5(),
                  show7Day = false,
                  show5Month = true,
                },
                label: Text('Generate 5 month Graph'),
                icon: Icon(
                  Icons.check,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                "Legend: X-axis: Days or Months\nY-axis: Hours slept\nTouch bar to see total hours slept\n5.36 = 5 hours and 36 minutes"
              ),
            ),
          ),
        ],
    );
  }

  Widget _build7DayTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1.0, 10.0, 0.0, 1.0),
      child: Container(
        height: 30,
        child: Text(
          'Generated graph from last 7 days of sleep',
          textAlign: TextAlign.center,
        )
      )
    );
  }
  Widget _build7Day() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: const EdgeInsets.all(2.0),
        height: 200,
        child: BarChart(
          BarChartData (
            backgroundColor: MyThemes.blizzardBlue,
            maxY: 25,
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 6,
                  rotateAngle: -45,
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
            barGroups: [BarChartGroupData(x: 0, barRods: [BarChartRodData(y: listy[0], colors: [barColor[0]], width: 10)]),
              BarChartGroupData(x: 1, barRods: [BarChartRodData(y: listy[1], colors: [barColor[0]], width: 10)]),
              BarChartGroupData(x: 2, barRods: [BarChartRodData(y: listy[2], colors: [barColor[0]], width: 10)]),
              BarChartGroupData(x: 3, barRods: [BarChartRodData(y: listy[3], colors: [barColor[0]], width: 10)]),
              BarChartGroupData(x: 4, barRods: [BarChartRodData(y: listy[4], colors: [barColor[0]], width: 10)]),
              BarChartGroupData(x: 5, barRods: [BarChartRodData(y: listy[5], colors: [barColor[0]], width: 10)]),
              BarChartGroupData(x: 6, barRods: [BarChartRodData(y: listy[6], colors: [barColor[0]], width: 10)]),],
          ),
        ),
      ),
    );
  }

  Widget _build5MonthTitle() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(1.0, 10.0, 0.0, 1.0),
        child: Container(
            height: 30,
            child: Text(
              'Generated graph from last 5 months of sleep',
              textAlign: TextAlign.center,
            )
        )
    );
  }
  Widget _build5Month() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(2.0),
        height: 300,
        child: BarChart(
          BarChartData (
            backgroundColor: MyThemes.blizzardBlue,
            maxY: 168,
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 4,
                  rotateAngle: -45,
                  getTitles: (value) {
                    switch (value.toInt()) {
                      case 0:
                        return monthX[0];
                      case 1:
                        return monthX[1];
                      case 2:
                        return monthX[2];
                      case 3:
                        return monthX[3];
                      case 4:
                        return monthX[4];
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
            barGroups: [BarChartGroupData(x: 0, barRods: [BarChartRodData(y: monthY[0], colors: [barColor[0]], width: 10)]),
              BarChartGroupData(x: 1, barRods: [BarChartRodData(y: monthY[1], colors: [barColor[0]], width: 10)]),
              BarChartGroupData(x: 2, barRods: [BarChartRodData(y: monthY[2], colors: [barColor[0]], width: 10)]),
              BarChartGroupData(x: 3, barRods: [BarChartRodData(y: monthY[3], colors: [barColor[0]], width: 10)]),
              BarChartGroupData(x: 4, barRods: [BarChartRodData(y: monthY[4], colors: [barColor[0]], width: 10)])],
          ),
        ),
      ),
    );
  }
}