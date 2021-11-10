//bar_chart_data
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';

List<double> dayArr = List.filled(10,0.0);

List<BarChartGroupData> barChartGroupData = [
  BarChartGroupData(x: 1, barRods: [
    BarChartRodData(y: 9.0, colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 2, barRods: [
    BarChartRodData(y: 8.0, colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 3, barRods: [
    BarChartRodData(y: dayArr[2], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 4, barRods: [
    BarChartRodData(y: dayArr[3], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 5, barRods: [
    BarChartRodData(y: dayArr[4], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 6, barRods: [
    BarChartRodData(y: dayArr[5], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 7, barRods: [
    BarChartRodData(y: dayArr[6], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
];