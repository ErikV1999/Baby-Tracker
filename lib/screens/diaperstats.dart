import 'package:baby_tracker/models/feedingChartData.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:baby_tracker/models/diaperchangechart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class diaperstats extends StatefulWidget {
  final String baby;

  const diaperstats({Key? key, required this.baby}) : super(key: key);
  @override
  _diaperstats createState() => _diaperstats();
}

class _diaperstats extends State<diaperstats> {
  var listy = List<double>.filled(7,0.0);
  late List<BarChartGroupData> showingBarGroups;
  @override
  void initState()
    {
      super.initState();

      generateData(); //gets data from database
      //generate(); // puts data in charts
      final barGroup1 = makeGroupData(0, 0, 0, 0);
      final barGroup2 = makeGroupData(1, 0, 0, 0);
      final barGroup3 = makeGroupData(2, 0, 0, 0);
      final barGroup4 = makeGroupData(3, 0, 0, 0);
      final barGroup5 = makeGroupData(4, 0, 0, 0);
      final barGroup6 = makeGroupData(5, 0, 0, 0);
      final barGroup7 = makeGroupData(6, 0, 0, 0);

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


    }

  List<diaperChange> myList = [];

  Future<void> generateData() async{
    Query _sleepRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change').orderBy("date", descending: true);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _sleepRef2.get();
    for(int i = 0; i < dayArrDC.length;i++)
      {
        dayArrDC[i] = 0.0;
      }

    showingBarGroups.clear();
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
    print("hello");
    //checks if day is a dry day and adds to list, will change in next sprint with more columns
    for( var i = 0; i < myList.length;i++){
      //print((myList[i].dateOf).day.toString() + " and " + dayArr[i].toString());

      if(myList[i].statusOf == "Dry" && (i< 7)){
        dryTally +=1;
        dayArrDC[i] += 1;
        //print(i.toString() + " is this " + myList[i].statusOf + " and " + dayArrDC[i].toString());
      }if(myList[i].statusOf == "Wet" && (i< 7)){
        wetTally += 1;
        //dayArrDC[i] += 1;
        //print(i.toString() + " is this " + myList[i].statusOf + " and " + dayArrDC[i].toString());
      }
      if(myList[i].statusOf == "Mix" && (i< 7)){
        mixTally += 1;
        //dayArrDC[i] += 1;
        //print(i.toString() + " is this " + myList[i].statusOf + " and " + dayArrDC[i].toString());
      }
      final barGrouptemp = makeGroupData(i, dryTally, wetTally, mixTally);
      showingBarGroups.add(barGrouptemp);
      print("Dry, wet, mix and I" + dryTally.toString() + wetTally.toString() + mixTally.toString());
      //reset for next loop
      dryTally = wetTally = mixTally = 0;
    }
    /*listy[0] = dayArrDC[0];
    listy[1] = dayArrDC[1];
    listy[2] = dayArrDC[2];
    listy[3] = dayArrDC[3];
    listy[4] = dayArrDC[4];
    listy[5] = dayArrDC[5];
    listy[6] = dayArrDC[6];*/
    print("AFTER PRINT");
  }
  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    double widths = 7;
    return BarChartGroupData(barsSpace: 10, x: x, barRods: [
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
      listy[0] = dayArrDC[0];
      listy[1] = dayArrDC[1];
      listy[2] = dayArrDC[2];
      listy[3] = dayArrDC[3];
      listy[4] = dayArrDC[4];
      listy[5] = dayArrDC[5];
      listy[6] = dayArrDC[6];
    });
  }

  
  Widget build(BuildContext context) {
    Query sleepRef = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change').orderBy("indexDate", descending: true);
    CollectionReference _sleepRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change');
    String babyPath = widget.baby;
    return ListView(
      children: [Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.blue,
          height: 400,
          child: BarChart(
            BarChartData (
              maxY: 5,
              barGroups: showingBarGroups,
              /*[BarChartGroupData(x: 1, barRods: [BarChartRodData(y: listy[0])]),
                BarChartGroupData(x: 2, barRods: [BarChartRodData(y: listy[1])]),
                BarChartGroupData(x: 3, barRods: [BarChartRodData(y: listy[2])]),
                BarChartGroupData(x: 4, barRods: [BarChartRodData(y: listy[3])]),
                BarChartGroupData(x: 5, barRods: [BarChartRodData(y: listy[4])]),
                BarChartGroupData(x: 6, barRods: [BarChartRodData(y: listy[5])]),
                BarChartGroupData(x: 7, barRods: [BarChartRodData(y: listy[6])]),],*/
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