//bar_chart_data
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

List<double> dayArr = List.filled(32,0.0);
List<String> dayArr2 = List.filled(10, '-');
List<double> monthArr = List.filled(13,0.0);
List<String> monthArr2 = List.filled(7, '-');
class daysPerMonth {
  final int MONTH;
  final int DAYS;

  const daysPerMonth({
    required this.MONTH,
    required this.DAYS,
});
}
class DaysMonth {

  static List<daysPerMonth> dayMonth = [
    daysPerMonth(
      MONTH: 1,
      DAYS: 31,
    ),
    daysPerMonth(
      MONTH: 2,
      DAYS: 28,
    ),
    daysPerMonth(
      MONTH: 3,
      DAYS: 31,
    ),
    daysPerMonth(
      MONTH: 4,
      DAYS: 30,
    ),
    daysPerMonth(
      MONTH: 5,
      DAYS: 31,
    ),
    daysPerMonth(
      MONTH: 6,
      DAYS: 30,
    ),
    daysPerMonth(
      MONTH: 7,
      DAYS: 31,
    ),
    daysPerMonth(
      MONTH: 8,
      DAYS: 31,
    ),
    daysPerMonth(
      MONTH: 9,
      DAYS: 30,
    ),
    daysPerMonth(
      MONTH: 10,
      DAYS: 31,
    ),
    daysPerMonth(
      MONTH: 11,
      DAYS: 30,
    ),
    daysPerMonth(
      MONTH: 12,
      DAYS: 31,
    ),
    daysPerMonth(
      MONTH: 22,
      DAYS: 29,
    ),
  ];
}