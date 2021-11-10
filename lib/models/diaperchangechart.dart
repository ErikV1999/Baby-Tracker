import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';

class diaperChange{
  final DateTime dateOf;
  final String statusOf;
  diaperChange(this.dateOf, this.statusOf);

  //check if null or not, if not then assign to
  diaperChange.fromMap(Map<String,dynamic> map)
  :assert(map['dateOf']!=null),
  assert(map['statusOf']!=null),
    dateOf=map['dateOf'],
    statusOf=map['statusOf'];
}


List<double> dayArrDC = List.filled(10,0.0);

List<BarChartGroupData> barChartGroupData = [
  BarChartGroupData(x: 1, barRods: [
    BarChartRodData(y: 9.0, colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 2, barRods: [
    BarChartRodData(y: 8.0, colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 3, barRods: [
    BarChartRodData(y: dayArrDC[2], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 4, barRods: [
    BarChartRodData(y: dayArrDC[3], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 5, barRods: [
    BarChartRodData(y: dayArrDC[4], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 6, barRods: [
    BarChartRodData(y: dayArrDC[5], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
  BarChartGroupData(x: 7, barRods: [
    BarChartRodData(y: dayArrDC[6], colors: [Color(0xff43dde6), Color(0xff43dde6)]),
  ]),
];