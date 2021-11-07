//barChart
import 'package:fl_chart/fl_chart.dart';
import 'package:baby_tracker/models/sleepingChartData.dart';
import 'package:baby_tracker/models/populateData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BarChartContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    populate();
    return BarChart(
      BarChartData(
        maxY: 16,
        barGroups: barChartGroupData,
      ),
    );
  }
}