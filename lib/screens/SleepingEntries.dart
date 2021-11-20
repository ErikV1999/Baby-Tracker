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
    int currDate = 0;

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    //print(dayArr[0]);

    querySnapshot.docs.forEach((doc) {
      if (currDate == 0) {
        currDate = doc["indexDate"];
      }
      if (currDate == doc["indexDate"]){
        temp = temp + doc["TotalHoursSlept"].toDouble();
      }
      else {
        print("$temp, $count");
        if (count < 7) {
          dayArr[count] = temp;
          currDate = doc["indexDate"];
          temp = 0;
          temp = temp + doc["TotalHoursSlept"].toDouble();
          count++;
        }
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
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map data = snapshot.data!.docs[index].data() as Map;
                return GestureDetector(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data['Notes']}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text("Date: " "${data['SleepingDate']}, " +
                              "Start:" + "${data['StartSleeping']}," +
                              "Woke Up:" + "${data['StopSleeping']},",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          )
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