import 'package:flutter/material.dart';
import 'package:baby_tracker/models/chartContainer.dart';
import 'package:baby_tracker/models/barChart.dart';
import 'package:baby_tracker/models/sleepingChartData.dart';

class debugPage extends StatefulWidget {
  final String baby;

  const debugPage({Key? key, required this.baby}) : super(key: key);

  @override
  _debugPageState createState() => _debugPageState();
}

class _debugPageState extends State<debugPage> {

  @override
  Widget build(BuildContext context) {
    String babyPath = widget.baby;
    return Scaffold(
        appBar: AppBar(
          title: Text('debug page, messing with graphs',
          style: TextStyle(fontSize: 15),),
        ),
        body: Container(
          color: Color(0xfff0f0f0),
          child: ListView(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            children: <Widget>[
              ChartContainer(
                title: 'Line Chart',
                color: Color.fromRGBO(45, 108, 223, 1),
                chart: BarChartContent(),
              ),
            ],
          ),
        ));
  }
}