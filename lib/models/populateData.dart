//barChart
import 'package:fl_chart/fl_chart.dart';
import 'package:baby_tracker/models/sleepingChartData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class populate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    y0 = 15.0;
    y1 = 10.0;
    y2 = 8.0;
    y3 = 5.0;
    y4 = 12.0;
    return BarChart(
      BarChartData(
      ),
    );
  }
}