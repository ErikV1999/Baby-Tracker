import 'package:baby_tracker/models/sleepingChartData.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/SleepingStats.dart';

class SleepingEntries extends StatefulWidget {

  final String baby;

  const SleepingEntries({Key? key, required this.baby}) : super(key: key);
  @override
  _SleepingEntriesState createState() => _SleepingEntriesState();
}

class _SleepingEntriesState extends State<SleepingEntries> {

  Future<void> generateData() async{
    Query _sleepRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('sleeping').orderBy("indexDate", descending: true);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _sleepRef2.get();
    int count = 0;
    double temp = 0.0;
    double minuTemp = 0.0;
    int currDate = 0;

    String dateStr = 'a';
    String monthStr = 'a';

    for (int i = 0; i < 32; i++)
    {
      dayArr[i] = 0.0;
    }
    for (int i = 0; i < 10; i++)
    {
      dayArr2[i] = '-';
    }

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    int len = allData.length;

    //print(dayArr[0]);

    querySnapshot.docs.forEach((doc) {

      len--;
      // get the first current date, should be the latest entry
      if (currDate == 0) {
        currDate = doc["indexDate"];
      }
      //print(currDate);


      // if the next entry has the same currDate, meaning data was enter
      // on the same day, temp will add total hours slept to current temp
      // will total all hours slept on the specified indexDate
      if (currDate == doc["indexDate"]){
        temp = temp + doc["TotalHoursSlept"].toDouble();
        minuTemp = minuTemp + doc["TotalMinutesSlept"].toDouble();
        dateStr = doc["SleepingDate"].substring(0,5); // save the date
        print(dateStr);
        //print(currDate.toString() + " - " + temp.toString() + " index: " + doc["indexDate"].toString());
      }
      // when the currDate changes, indicated a new date of data entries,
      // will save the totaled hours slept to dayArr in one of the 7 indexes.
      // also substring the sleeping date to remove the year and leave only the
      // month-date. assign that to dayArr2. set the new currdate and begin
      // totaling the new total hours slept.
      else {
        print("$temp, $count");
        if (count < 7) {
          dayArr[count] = temp;
          currDate = doc["indexDate"];
          //print("$temp, $count");
          if (count < 7) { // only want 7 days
            while (minuTemp > 60.0){
              minuTemp = minuTemp - 60.0;
              temp = temp + 1.0;
            }
            print(minuTemp/100.0);
            temp = temp + (minuTemp/100.0);
            dayArr[count] = temp; // save the temp total hours for previous day
            dayArr2[count] = dateStr; // save the date of the previous day
            print("count: " + count.toString() + " date: " + dateStr + " total: " + temp.toString());
            currDate = doc["indexDate"]; // change current date to new date
            dateStr = doc["SleepingDate"].substring(0,5); // set new date
            print(dateStr);
            //print("date " + doc["SleepingDate"] + " total hours " + temp.toString());
            temp = 0; // reset total hours
            temp = temp + doc["TotalHoursSlept"].toDouble(); // start adding to total hours from new day
            minuTemp = 0;
            minuTemp = minuTemp + doc["TotalMinutesSlept"].toDouble();
            count++; // increase count
          }
        }
        if (count < 7 && len == 0)
        {
          while (minuTemp > 60.0){
            minuTemp = minuTemp - 60.0;
            temp = temp + 1.0;
          }
          print(minuTemp/100.0);
          temp = temp + (minuTemp/100.0);
          dayArr[count] = temp; // save the temp total hours for previous day
          dayArr2[count] = dateStr; // save the date of the previous day
        }
      }});
    }

  Future<void> generateDataMonthly() async{
    Query _sleepRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('sleeping').orderBy("indexDate", descending: true);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _sleepRef2.get();
    int count = 0;
    double temp = 0.0;
    double minuTemp = 0.0;
    int currDate = 0;
    int currMonth = 0;
    String dateStr = 'a';
    String monthStr = 'a';

    for (int i = 0; i < 13; i++)
    {
      monthArr[i] = 0.0;
    }
    for (int i = 0; i < 7; i++)
    {
      monthArr2[i] = '-';
    }
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    int len = allData.length;

    //print(dayArr[0]);

    querySnapshot.docs.forEach((doc) {
      // get the first current date, should be the latest entry
      len--;
      //print("date" + doc["indexDate"].toString());
      if (currDate == 0) {
        currDate = 1;
        monthStr = doc["indexDate"].toString().substring(0,6);
        //print(monthStr);
      }
      // if the next entry has the same currDate, meaning data was enter
      // on the same day, temp will add total hours slept to current temp
      // will total all hours slept on the specified indexDate
      if (monthStr == doc["indexDate"].toString().substring(0,6)){
        temp = temp + doc["TotalHoursSlept"].toDouble();
        minuTemp = minuTemp + doc["TotalMinutesSlept"].toDouble();
        dateStr = doc["SleepingDate"].substring(0,2);
        dateStr = dateStr + '-' + monthStr.substring(0,4);
        //print(monthStr);
      }
      // when the currDate changes, indicated a new date of data entries,
      // will save the totaled hours slept to dayArr in one of the 7 indexes.
      // also substring the sleeping date to remove the year and leave only the
      // month-date. assign that to dayArr2. set the new currdate and begin
      // totaling the new total hours slept.
      else {
        //print("$temp, $count");
        if (count < 5) {
          while (minuTemp > 60.0){
            minuTemp = minuTemp - 60.0;
            temp = temp + 1.0;
          }
          print(minuTemp/100.0);
          temp = temp + (minuTemp/100.0);
          monthArr[count] = temp; // save the total hours slept for a month
          monthArr2[count] = dateStr; // save previous date
          dateStr = doc["SleepingDate"].substring(0,2);
          dateStr = dateStr + '-' + monthStr.substring(0,4); // format month - year ex: 10-2021
          monthStr = doc["indexDate"].toString().substring(0,6); // set new month string
          //print("month total " + temp.toString());
          temp = 0;
          temp = temp + doc["TotalHoursSlept"].toDouble();
          minuTemp = 0;
          minuTemp = minuTemp + doc["TotalMinutesSlept"].toDouble();
          count++;
        }
      }
      if (count < 5 && len == 0) // reached end of entries but not 5 months yet
          {
        while (minuTemp > 60.0){
          minuTemp = minuTemp - 60.0;
          temp = temp + 1.0;
        }
        print(minuTemp/100.0);
        temp = temp + (minuTemp/100.0);
        monthArr[count] = temp; // save the total hours slept for a month
        dateStr = doc["SleepingDate"].substring(0,2);
        dateStr = dateStr + '-' + monthStr.substring(0,4); // format month - year ex: 10-2021
        monthArr2[count] = dateStr;
        monthStr = doc["indexDate"].toString().substring(0,6);
        //print("month total " + temp.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Query sleepRef = FirebaseFirestore.instance.doc(widget.baby).collection('sleeping').orderBy("indexDate", descending: true);
    CollectionReference _sleepRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('sleeping');
    String babyPath = widget.baby;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //title: Text(babyPath),
        title: Text('Sleeping Entries',
          style: TextStyle(color: Colors.black, fontSize: 20,),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: sleepRef.get(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            generateData();
            generateDataMonthly();
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map data = snapshot.data!.docs[index].data() as Map;
                return GestureDetector(
                  onTap: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          AlertDialog(
                            title: const Text('Delete Sleeping Entry?'),
                            content: Text("Notes: " + "${data['Notes']}",),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  snapshot.data!.docs[index].reference.delete();
                                  setState(() {

                                  });
                                  Navigator.pop(context, 'OK');
                                },
                                child: const Text('Delete', style: TextStyle(color: Colors.red),),
                              ),
                            ],
                          ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date: ${data['SleepingDate']}\n"
                              "Total Sleep: ${data['TotalHoursSlept']} Hours & "
                              "${data['TotalMinutesSlept']} Minutes",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text("Started: " + "${data['StartSleeping']} " +
                              "Woke Up: " + "${data['StopSleeping']},",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }else {
            return Center(child: Text('Loading...'));
          }
        },
      ),
    );
  }
}