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
  @override
  void initState()
    {
      super.initState();
      //generate(); // puts data in charts
      generateData(); //gets data from database


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


    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    querySnapshot.docs.forEach((doc) {
      final Timestamp timestop = doc['date'];
      final DateTime date = timestop.toDate();
      diaperChange newdiaperc = new diaperChange(date, doc['status'],);
      myList.add(newdiaperc);
      });
    //checks if day is a dry day and adds to list, will change in next sprint with more columns
    for( var i = 0; i < myList.length;i++){
      //print((myList[i].dateOf).day.toString() + " and " + dayArr[i].toString());

      if(myList[i].statusOf == "Dry" && (i< 7)){
        dayArrDC[i] += 1;
        print(i.toString() + " is this " + myList[i].statusOf + " and " + dayArrDC[i].toString());
      }
    }
    listy[0] = dayArrDC[0];
    listy[1] = dayArrDC[1];
    listy[2] = dayArrDC[2];
    listy[3] = dayArrDC[3];
    listy[4] = dayArrDC[4];
    listy[5] = dayArrDC[5];
    listy[6] = dayArrDC[6];
    print("AFTER PRINT");
  }
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
          height: 200,
          child: BarChart(
            BarChartData (
              maxY: 5,
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