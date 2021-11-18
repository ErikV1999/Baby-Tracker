import 'package:baby_tracker/models/feedingChartData.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:baby_tracker/models/diaperchangechart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class diaperstats extends StatefulWidget {
  final String baby;

  const diaperstats({Key? key, required this.baby}) : super(key: key);
  @override
  _diaperstats createState() => _diaperstats();
}

class _diaperstats extends State<diaperstats> {
  var listy = List<double>.filled(7,0.0);
  late List<BarChartGroupData> showingBarGroups;
  int daysLength = 7;
  @override
  void initState()
    {
      super.initState();
      final barGroup1 = makeGroupData(0, 4, 5, 1);
      final barGroup2 = makeGroupData(1, 0, 0, 0);
      final barGroup3 = makeGroupData(2, 0, 0, 0);
      final barGroup4 = makeGroupData(3, 0, 0, 0);
      final barGroup5 = makeGroupData(4, 0, 0, 0);
      final barGroup6 = makeGroupData(5, 0, 0, 0);
      final barGroup7 = makeGroupData(6, 2, 2, 2);

      final items = [
        barGroup1,
        barGroup2,
        barGroup3,
        barGroup4,
        barGroup5,
        barGroup6,
        barGroup7,
      ];
      showingBarGroups = items;
      generateDataSeven(); //gets data from database
      //generate(); // puts data in charts
    }

  List<diaperChange> myList = [];
  List<BarChartGroupData> dataList = [];

  Future<void> generateDataSeven() async{
    Query _diaperRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change').orderBy("date", descending: true);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _diaperRef2.get();
    //Clear previous data
    myList.clear();
    dataList.clear();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    querySnapshot.docs.forEach((doc) {
      final Timestamp timestop = doc['date'];
      final DateTime date = timestop.toDate();
      diaperChange newdiaperc = new diaperChange(date, doc['status'],);
      myList.add(newdiaperc);
      });

    double dryTally = 0;
    double wetTally = 0;
    double mixTally = 0;
    int day = 0; //keep track how how many days
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    DateTime permNow = date;
    DateTime lastDay = now.subtract(Duration(days: 7));
    print("NEw " + lastDay.toString() + " \nand old " + permNow.toString());
    //Going to have to be able to test on days where there is no input as of 11/18 10am it can not 
    for( int i = 0; i < myList.length;i++){
      if(permNow.difference(myList[i].dateOf).inDays == 8)
      {
        break;
      }
      if( ((date.difference(myList[i].dateOf).inDays)==0) &&
          ( ((date.month) == (myList[i].dateOf).month) && ((date.day) == (myList[i].dateOf).day)) )
        {
          if(myList[i].statusOf == "Dry"){// && (i< 7)){
            dryTally +=1;
          }
          if(myList[i].statusOf == "Wet"){// && (i< 7)){
            wetTally += 1;
          }
          if(myList[i].statusOf == "Mix"){// && (i< 7)) {
            mixTally += 1;
          }
        }
      else
        { //new day to reset before getting data
          date = myList[i].dateOf;
          //put data in groupdata then check next day
          final barGrouptemp = makeGroupData(day, dryTally, wetTally, mixTally);
          dryTally = wetTally = mixTally = 0; //reset for next loop
          dataList.add(barGrouptemp);
          day++; //its a new day so let graph show it
          if(myList[i].statusOf == "Dry"){// && (i< 7)){
            dryTally +=1;
          }
          if(myList[i].statusOf == "Wet"){// && (i< 7)){
            wetTally += 1;
          }
          if(myList[i].statusOf == "Mix"){// && (i< 7)) {
            mixTally += 1;
          }
        }
    }
    showingBarGroups = dataList;
    generate();
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    double widths = 7;
    return BarChartGroupData(barsSpace: 1, x: x, barRods: [
      BarChartRodData(
          y: y1,
      colors: [Color(0xFF3E2723)] ,// other one 0xffff5182
      width: widths,
    ),
    BarChartRodData(
    y: y2,
    colors: [Color(0xFF0D47A1)],
      width: widths,
    ),
    BarChartRodData(
        y: y3,
        colors: [Color(0xFF1B5E20)],
        width: widths,
      )
    ]);
  }//makeGroupData

  Future<void> generate() async{//set up chart data
    setState(() {
      showingBarGroups = dataList;
    });
  }

  
  Widget build(BuildContext context) {
    Query sleepRef = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change').orderBy("indexDate", descending: true);
    CollectionReference _sleepRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change');
    String babyPath = widget.baby;
    String axisMessage = "Past 7 days from " + DateFormat('Md').format(DateTime.now());
    return ListView(
      children: [Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          height: 400,
          child: BarChart(
            BarChartData (
              maxY: 5,
              barGroups: showingBarGroups,
              titlesData: FlTitlesData(
                show: true,
                rightTitles: SideTitles(showTitles: false),
                topTitles: SideTitles(showTitles: false),

              ),
              gridData: FlGridData(show: true),
              axisTitleData: FlAxisTitleData(
                show: true,
                bottomTitle: AxisTitle(showTitle:true, titleText: axisMessage, margin: 20.0),
                leftTitle: AxisTitle(showTitle:true, titleText: "Number of occurrences", margin: 0.0),
              ),
            ),
          ),
        ),
      ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: ElevatedButton.icon(
              onPressed: () => generateDataSeven(),
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
              onPressed: () => generateDataSeven(),
              label: Text('Generate 30 Day Graph'),
              icon: Icon(
                Icons.check,
              ),
            ),
          ),
        ),
      ],
    );
  }
}