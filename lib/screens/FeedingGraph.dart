import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/models/feedingChartData.dart';

class FeedingGraphs extends StatefulWidget {

  final String baby;

  const FeedingGraphs({Key? key, required this.baby}) : super(key: key);
  @override
  _FeedingGraphsState createState() => _FeedingGraphsState();
}

class _FeedingGraphsState extends State<FeedingGraphs> {
  var listy = List<double>.filled(7,1.0);
  var listx = List<int>.filled(7,0);

  Future<void> generate() async{
    setState(() {
      listy[0] = dayArr[0];
      listy[1] = dayArr[1];
      listy[2] = dayArr[2];
      listy[3] = dayArr[3];
      listy[4] = dayArr[4];
      listy[5] = dayArr[5];
      listy[6] = dayArr[6];
    });
  }

  @override
  Widget build(BuildContext context) {
    Query feedRef = FirebaseFirestore.instance.doc(widget.baby).collection('feeding').orderBy("index date", descending: true);
    String babyPath = widget.baby;

    return ListView(
      children: [Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.blue,
          height: 250,
          child: BarChart(
            BarChartData (
              maxY: 15,
              barGroups: [BarChartGroupData(x: 1, barRods: [BarChartRodData(y: listy[0])]),
                BarChartGroupData(x: 2, barRods: [BarChartRodData(y: listy[1])]),
                BarChartGroupData(x: 3, barRods: [BarChartRodData(y: listy[2])]),
                BarChartGroupData(x: 4, barRods: [BarChartRodData(y: listy[3])]),
                BarChartGroupData(x: 5, barRods: [BarChartRodData(y: listy[4])]),
                BarChartGroupData(x: 6, barRods: [BarChartRodData(y: listy[5])]),
                BarChartGroupData(x: 7, barRods: [BarChartRodData(y: listy[6])]),],
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