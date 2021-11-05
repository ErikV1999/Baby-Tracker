//bar_chart_data
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';

List<double> dayArr = List.filled(5,0.0);
double y0 = 0.0;
double y1 = 0.0;
double y2 = 0.0;
double y3 = 0.0;
double y4 = 0.0;
double y5 = 0.0;


List<BarChartGroupData> barChartGroupData = [
  BarChartGroupData(x: 1, barRods: [
    BarChartRodData(y: 15.0, colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 2, barRods: [
    BarChartRodData(y: y1, colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 3, barRods: [
    BarChartRodData(y: y2, colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 4, barRods: [
    BarChartRodData(y: y3, colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 5, barRods: [
    BarChartRodData(y: y4, colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 6, barRods: [
    BarChartRodData(y: y5, colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 7, barRods: [
    BarChartRodData(y: y5, colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
];