import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:baby_tracker/models/diaperchangechart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class diapergraph extends StatefulWidget {
  final String baby; //path of baby in database

  const diapergraph({Key? key, required this.baby}) : super(key: key);
  @override
  _diapergraph createState() => _diapergraph();
}

class _diapergraph extends State<diapergraph> {
  //var listy = List<double>.filled(7,0.0);           //a list for holding data for graph
  late List<BarChartGroupData> showingBarGroups;    //hold data for graph
  //int daysLength = 7;                               //will delete later
  @override
  void initState()
  {
    //following is to fill graph with information on a 7 day week
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
    showingBarGroups = items; //give graph data
    generateDataSeven(); //gets data from database
  }

  List<diaperChange> myList = [];//list for holding data from database
  List<BarChartGroupData> dataList = [];//hold list that will be given to graph
  String axisMessage = "Number of days ago from " + DateFormat('Md').format(DateTime.now());//message for x-axis
  String axisMessage1 = "Number of days ago from " + DateFormat('Md').format(DateTime.now());//message for a-axis if 7 day week shown
  String axisMessage2 = "Last 4 weeks starting from " + DateFormat('Md').format(DateTime.now());//message for a-axis if 30 day week shown

  Future<void> generateDataSeven() async{
    Query _diaperRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change').orderBy("date", descending: true);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _diaperRef2.get();
    //Clear previous data
    myList.clear();//clear list of previous data
    dataList.clear();//clear list of previous data
    axisMessage = axisMessage1;//have axis be 7 day message

    //following gets list of data and puts it in myList, changes date into Datetime for graph
    querySnapshot.docs.forEach((doc) {
      final Timestamp timestop = doc['date'];
      final DateTime date = timestop.toDate();
      diaperChange newdiaperc = new diaperChange(date, doc['status'],);
      myList.add(newdiaperc);
    });

    double dryTally = 0;  //holds number of times baby had a dry diaper for this day
    double wetTally = 0;  //holds number of times baby had a wet diaper for this day
    double mixTally = 0;  //holds number of times baby had a mix diaper for this day
    int day = 0; //keep track how how many days
    DateTime now = new DateTime.now();//get current day
    DateTime date = new DateTime(now.year, now.month, now.day);//make current day be 00.00 hours and minutes, makes using difference in days eaiser to use
    DateTime loopTime = date; //date for loop
    DateTime loopTime2 = date;//date for loop
    DateTime lastDay = now.subtract(Duration(days: 8));//get 8 days ago and use it to stop loop for print previous 7 days
    DateTime lastDay2 = new DateTime(lastDay.year, lastDay.month, lastDay.day);//make current day be 00.00 hours and minutes, makes using difference in days eaiser to use

    while(!(lastDay2.difference(loopTime).inDays >= 0))//stop when loopTime equals last day(8 days ago)
    {
      //loopTime will have next loop, loopTime2 will contain current time to check in database
      loopTime = loopTime2.subtract(Duration(days: 1));
      //loop thru myList to get days that equal this loopTime and add to either dryTally, wetTally, or mixTally
      for(int i = 0; i < myList.length;i++) {
        if (((loopTime2
            .difference(myList[i].dateOf).inDays) == 0) &&
            (((loopTime2.month) == (myList[i].dateOf).month) &&
                ((loopTime2.day) == (myList[i].dateOf).day))) { //if true then check status of diaper and add to list
          if (myList[i].statusOf == "Dry") { // && (i< 7)){
            dryTally += 1;
          }
          if (myList[i].statusOf == "Wet") { // && (i< 7)){
            wetTally += 1;
          }
          if (myList[i].statusOf == "Mix") { // && (i< 7)) {
            mixTally += 1;
          }
        }
      }
      //add data to graph and get ready for next loop, day is for X-axis
      final barGrouptemp = makeGroupData(day, dryTally, wetTally, mixTally);
      dryTally = wetTally = mixTally = 0; //reset for next loop
      dataList.add(barGrouptemp); //add data to bargraphdata for graph
      day++; //set for next day
      loopTime2 = loopTime; //set loopTime2 to yesterday for next loop iteration, if past 7 days then end while loop
    }
    showingBarGroups = dataList; //give data to showingBarGroups so data shows up on graph
    generate();
  }
  Future<void> generateDataThirty() async{
    Query _diaperRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change').orderBy("date", descending: true);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _diaperRef2.get();
    //Clear previous data
    myList.clear();//clear list of previous data
    dataList.clear();//clear list of previous data
    axisMessage = axisMessage2;//set a-axis to 30 day message

    //following gets list of data and puts it in myList, changes date into Datetime for graph
    querySnapshot.docs.forEach((doc) {
      final Timestamp timestop = doc['date'];
      final DateTime date = timestop.toDate();
      diaperChange newdiaperc = new diaperChange(date, doc['status'],);
      myList.add(newdiaperc);
    });

    double dryTally = 0;//hold times baby had a dry diaper
    double wetTally = 0;//hold times baby had a wet diaper
    double mixTally = 0;//hold times baby had a mix diaper
    int day = 0; //keep track how how many days
    DateTime now = new DateTime.now();//get current day
    DateTime date = new DateTime(now.year, now.month, now.day);//make current day be 00.00 hours and minutes, makes using difference in days easier to use
    DateTime loopTime = date;//date for loop
    DateTime loopTime2 = date;//date for loop
    DateTime endOfWeek = now.subtract(Duration(days: 7));//get date for end of week
    DateTime endOfWeektemp = now.subtract(Duration(days: 7));//get date for end of week
    DateTime lastDay = now.subtract(Duration(days: 31)); //get final day(31 day ago
    DateTime lastDay2 = new DateTime(lastDay.year, lastDay.month, lastDay.day);//make it easier to use difference

    while(!(lastDay2.difference(loopTime).inDays >= 0))//continue to loop until day equal or greater than final day
    {
      //check first week
      DateTime thisweek = loopTime.subtract(Duration(days: 8));//get final day of week
      while(!(thisweek.difference(loopTime).inDays >= 0))//continue until day equals or greater than final day of week
      {
        //loopTime will have next loop, loopTime2 will contain current time to check in database
        loopTime = loopTime2.subtract(Duration(days: 1));
        //check myList for days that equal current day and add status to that tally
        for (int i = 0; i < myList.length; i++) {
          if (((loopTime2
              .difference(myList[i].dateOf)
              .inDays) == 0) &&
              (((loopTime2.month) == (myList[i].dateOf).month) &&
                  ((loopTime2.day) == (myList[i].dateOf)
                      .day))) { //if true then check status of diaper and add to list
            if (myList[i].statusOf == "Dry") { // && (i< 7)){
              dryTally += 1;
            }
            if (myList[i].statusOf == "Wet") { // && (i< 7)){
              wetTally += 1;
            }
            if (myList[i].statusOf == "Mix") { // && (i< 7)) {
              mixTally += 1;
            }
          }
        }
        loopTime2 = loopTime;//set loopTime2 to yesterday for next loop iteration, if past 7 days then end while loop
      }//week while loop
      dryTally = dryTally / 7;  //get 7 day average
      wetTally = wetTally / 7;  //get 7 day average
      mixTally = mixTally / 7;  //get 7 day average
      endOfWeek = endOfWeektemp.subtract(Duration(days: 7)); //get next week's last day
      //add data to graph and get ready for next loop
      final barGrouptemp = makeGroupData(day, dryTally, wetTally, mixTally);
      dryTally = wetTally = mixTally = 0; //reset for next loop
      dataList.add(barGrouptemp);//add to dataList
      day++; //set for next day
      endOfWeektemp = endOfWeek;//get next week ready
    }//whole while loop
    showingBarGroups = dataList;  //give data to graph by giving it to showingBarGroups
    generate();//update graph
  }
  //following takes in
  //int x for x-axis, y1 for dryTally, y2 for wetTally, and y3 for MixTally
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

    return ListView(
      children: [Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          //following shows Fl bar chart
          //shows either 7 day or 30 day chart
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          height: 400,
          //width: 800,
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
          //following is a legend to read bar graph
          padding: const EdgeInsets.all(1.0),
          child: Container(
            child: RichText(
              textAlign:  TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "Blue is wet diapers |",
                    style: TextStyle(color: Colors.blue)
                ),
                TextSpan(
                    text: "| Green is Mix diapers |",
                    style: TextStyle(color: Colors.green)
                ),
                TextSpan(
                    text: "| Brown is dry diapers |",
                    style: TextStyle(color: Colors.brown)
                ),
              ]),
            ),
          ),
        ),
        Padding(
          //Following is a button, when pressed shows last 7 days diaper changes
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
          //Following is a button, when pressed shows last 30 days diaper changes average in 4 weeks
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: ElevatedButton.icon(
              onPressed: () => generateDataThirty(),
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
}