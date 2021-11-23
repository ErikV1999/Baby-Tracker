import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/models/feedingChartData.dart';
import 'package:intl/intl.dart';

class FeedingGraphs extends StatefulWidget {
  final String baby;

  const FeedingGraphs({Key? key, required this.baby}) : super(key: key);
  @override
  _FeedingGraphsState createState() => _FeedingGraphsState();
}

class _FeedingGraphsState extends State<FeedingGraphs> {
  var listy = List<double>.filled(7, 0.0);
  late List<BarChartGroupData> showingBarGroups;
  int daysLength = 7;

  bool show7Day = true;
  bool showMonth = false;
  String axisMessage =
      "Number of days ago from " + DateFormat('Md').format(DateTime.now());

  @override
  void initState() {
    super.initState();
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
    showingBarGroups = items; //give graph data
    generateDataSeven(); //gets data from database
  }

  List<FeedingData> myList = [];
  List<BarChartGroupData> dataList = [];

  Future<void> generateDataSeven() async {
    Query _feedRef = FirebaseFirestore.instance
        .doc(widget.baby)
        .collection('feeding')
        .orderBy("date", descending: true);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _feedRef.get();
    //Clear previous data
    myList.clear();
    dataList.clear();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    querySnapshot.docs.forEach((doc) {
      final Timestamp timestop = doc['date'];
      final DateTime date = timestop.toDate();
      FeedingData newFeeding = new FeedingData(
        date,
        doc['feeding type'],
      );
      myList.add(newFeeding);
    });

    double breastTally = 0;
    double bottleTally = 0;
    double foodTally = 0;
    int day = 0; //keep track how how many days
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    DateTime permNow = date;
    DateTime loopTime = date;
    DateTime loopTime2 = date;
    DateTime lastDay = now.subtract(Duration(days: 8));
    DateTime lastDay2 = new DateTime(lastDay.year, lastDay.month, lastDay.day);

    while (!(lastDay2.difference(loopTime).inDays >= 0)) {
      //loopTime will have next loop, loopTime2 will contain current time to check in database
      loopTime = loopTime2.subtract(Duration(days: 1));
      //print("First Loop " + loopTime.toString() + " and second " + loopTime2.toString());
      for (int i = 0; i < myList.length; i++) {
        if (((loopTime2.difference(myList[i].dateOf).inDays) == 0) &&
            (((loopTime2.month) == (myList[i].dateOf).month) &&
                ((loopTime2.day) == (myList[i].dateOf).day))) {
          if (myList[i].statusOf == "Left Breast" ||
              myList[i].statusOf == "Right Breast") {
            // && (i< 7)){
            breastTally += 1;
          }
          if (myList[i].statusOf == "Bottle") {
            // && (i< 7)){
            bottleTally += 1;
          }
          if (myList[i].statusOf == "Food") {
            // && (i< 7)) {
            foodTally += 1;
          }
        }
      }
      //add data to graph and get ready for next loop
      final barGrouptemp =
          makeGroupData(day, breastTally, bottleTally, foodTally);
      breastTally = bottleTally = foodTally = 0; //reset for next loop
      dataList.add(barGrouptemp);
      day++; //set for next day
      loopTime2 =
          loopTime; //set loopTime2 to yesterday for next loop iteration, if past 7 days then end while loop
    }
    showingBarGroups = dataList;
    generate();
  }

  Future<void> generateDataThirty() async {
    Query _feedingRef2 = FirebaseFirestore.instance
        .doc(widget.baby)
        .collection('feeding')
        .orderBy("date", descending: true);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _feedingRef2.get();
    //Clear previous data
    myList.clear();
    dataList.clear();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    querySnapshot.docs.forEach((doc) {
      final Timestamp timestop = doc['date'];
      final DateTime date = timestop.toDate();
      FeedingData newFeedingData = new FeedingData(
        date,
        doc['feeding type'],
      );
      myList.add(newFeedingData);
    });

    double breastTally = 0;
    double bottleTally = 0;
    double foodTally = 0;
    int day = 0; //keep track how how many days
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    DateTime loopTime = date;
    DateTime loopTime2 = date;
    DateTime endOfWeek = now.subtract(Duration(days: 7));
    DateTime endOfWeekTemp = now.subtract(Duration(days: 7));
    DateTime lastDay = now.subtract(Duration(days: 31)); //get final day
    DateTime lastDay2 = new DateTime(lastDay.year, lastDay.month,
        lastDay.day); //make it easier to use difference

    while (!(lastDay2.difference(loopTime).inDays >= 0)) {
      //check first week
      DateTime thisWeek = loopTime.subtract(Duration(days: 8));
      while (!(thisWeek.difference(loopTime).inDays >= 0)) {
        //loopTime will have next loop, loopTime2 will contain current time to check in database
        loopTime = loopTime2.subtract(Duration(days: 1));
        //print("First Loop " + loopTime.toString() + " and second " + loopTime2.toString());
        for (int i = 0; i < myList.length; i++) {
          if (((loopTime2.difference(myList[i].dateOf).inDays) == 0) &&
              (((loopTime2.month) == (myList[i].dateOf).month) &&
                  ((loopTime2.day) == (myList[i].dateOf).day))) {
            if (myList[i].statusOf == "Left Breast" ||
                myList[i].statusOf == "Right Breast") {
              // && (i< 7)){
              breastTally += 1;
            }
            if (myList[i].statusOf == "Bottle") {
              // && (i< 7)){
              bottleTally += 1;
            }
            if (myList[i].statusOf == "Food") {
              // && (i< 7)) {
              foodTally += 1;
            }
          }
        }
        loopTime2 =
            loopTime; //set loopTime2 to yesterday for next loop iteration, if past 7 days then end while loop
      } //week while loop
      breastTally = breastTally;
      bottleTally = bottleTally;
      foodTally = foodTally;
      endOfWeek = endOfWeekTemp.subtract(Duration(days: 7));
      //add data to graph and get ready for next loop
      final barGrouptemp =
          makeGroupData(day, breastTally, bottleTally, foodTally);
      breastTally = bottleTally = foodTally = 0; //reset for next loop
      dataList.add(barGrouptemp);
      day++; //set for next day
      endOfWeekTemp = endOfWeek; //get next week ready
    } //whole while loop
    showingBarGroups = dataList;
    generate();
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    double widths = 7;
    return BarChartGroupData(barsSpace: 1, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [Color(0xFFFF00BD)], // other one 0xffff5182
        width: widths,
      ),
      BarChartRodData(
        y: y2,
        colors: [Color(0xFF0063FF)],
        width: widths,
      ),
      BarChartRodData(
        y: y3,
        colors: [Color(0xFF00FF12)],
        width: widths,
      )
    ]);
  } //makeGroupData

  Future<void> generate() async {
    //set up chart data
    setState(() {
      showingBarGroups = dataList;
    });
  }

  Widget build(BuildContext context) {
    Query feedRef = FirebaseFirestore.instance
        .doc(widget.baby)
        .collection('feeding')
        .orderBy("date", descending: true);
    CollectionReference _feedRef2 =
        FirebaseFirestore.instance.doc(widget.baby).collection('feeding');
    String babyPath = widget.baby;
    return ListView(
      children: [
        if (show7Day == true) _build7DayTitle(),
        if (show7Day == true) _build7Day(),
        if (showMonth == true) _buildMonthTitle(),
        if (showMonth == true) _buildMonth(),
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: " Breast |",
                    style: TextStyle(color: Colors.pinkAccent)),
                TextSpan(
                    text: "| Bottle |",
                    style: TextStyle(color: Colors.blueAccent)),
                TextSpan(
                    text: "| Food ", style: TextStyle(color: Colors.green)),
              ]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: ElevatedButton.icon(
              onPressed: () => {
                generateDataSeven(),
                show7Day = true,
                showMonth = false,
              },
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
              onPressed: () => {
                generateDataThirty(),
                show7Day = false,
                showMonth = true,
              },
              label: Text('Generate 4 week summary'),
              icon: Icon(
                Icons.check,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _build7DayTitle() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(1.0, 10.0, 0.0, 1.0),
        child: Container(
            height: 30,
            child: Text(
              'Generated graph from the last 7 days for Feeding',
              textAlign: TextAlign.center,
            )));
  }

  Widget _build7Day() {
    axisMessage =
        "Number of days ago from " + DateFormat('Md').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        height: 400,
        //width: 800,
        child: BarChart(
          BarChartData(
            maxY: 15,
            barGroups: showingBarGroups,
            titlesData: FlTitlesData(
              show: true,
              rightTitles: SideTitles(showTitles: false),
              topTitles: SideTitles(showTitles: false),
            ),
            gridData: FlGridData(show: true),
            axisTitleData: FlAxisTitleData(
              show: true,
              bottomTitle: AxisTitle(
                  showTitle: true, titleText: axisMessage, margin: 20.0),
              leftTitle: AxisTitle(
                  showTitle: true, titleText: "Feeding Units", margin: 0.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthTitle() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(1.0, 10.0, 0.0, 1.0),
        child: Container(
            height: 30,
            child: Text(
              'Generated graph from the last months of Feeding',
              textAlign: TextAlign.center,
            )));
  }

  Widget _buildMonth() {
    axisMessage =
        "Number of weeks ago from " + DateFormat('Md').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        height: 400,
        //width: 800,
        child: BarChart(
          BarChartData(
            maxY: 50,
            barGroups: showingBarGroups,
            titlesData: FlTitlesData(
              show: true,
              rightTitles: SideTitles(showTitles: false),
              topTitles: SideTitles(showTitles: false),
            ),
            gridData: FlGridData(show: true),
            axisTitleData: FlAxisTitleData(
              show: true,
              bottomTitle: AxisTitle(
                  showTitle: true, titleText: axisMessage, margin: 20.0),
              leftTitle: AxisTitle(
                  showTitle: true, titleText: "Feeding Units", margin: 0.0),
            ),
          ),
        ),
      ),
    );
  }
}
