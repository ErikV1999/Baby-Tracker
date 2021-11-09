import 'package:baby_tracker/models/feedingChartData.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/FeedingStats.dart';

class FeedingEntries extends StatefulWidget {
  final String baby;

  const FeedingEntries({Key? key, required this.baby}) : super(key: key);
  @override
  _FeedingEntriesState createState() => _FeedingEntriesState();
}

class _FeedingEntriesState extends State<FeedingEntries> {

  Future<void> generateData() async{
    Query _feedRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('feeding').orderBy("index date", descending: true);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _feedRef2.get();
    int count = 0;
    int temp = 0;
    int currDate = 0;

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    //print(dayArr[0]);

    querySnapshot.docs.forEach((doc) {
      if (currDate == 0) {
        currDate = doc["index date"];
      }
      if (currDate == doc["index date"]){
        temp = temp + 1;
      }
      else {
        print("$temp, $count");
        if (count < 7) {
          dayArr[count] = temp.toDouble();
          currDate = doc["index date"];
          temp = 0;
          temp = temp + 1;
          count++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Query feedRef = FirebaseFirestore.instance
        .doc(widget.baby)
        .collection('feeding')
        .orderBy("index date", descending: true); //change to index day :p
    //CollectionReference _feedRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('feeding');
    String babyPath = widget.baby;

    return Scaffold(
      appBar: AppBar(
        //title: Text(babyPath),
        title: Text(
          'Feeding Entries',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: feedRef.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            generateData();
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map data = snapshot.data!.docs[index].data() as Map;
                return GestureDetector(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data['feeding type']}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          if ("${data['feeding type']}" == 'Left Breast')
                            _BreastEntry(data),
                          if ("${data['feeding type']}" == 'Right Breast')
                            _BreastEntry(data),
                          if ("${data['feeding type']}" == 'Bottle')
                            _BottleEntry(data),
                          if ("${data['feeding type']}" == 'Food')
                            _FoodEntry(data),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Loading...'));
          }
        },
      ),
    );
  }

  Widget _BreastEntry(Map data) {
    return Text(
        "Date: " +
            "${data['date']}\n" +
            "Time Fed: " +
            "${data['total Time in seconds']} seconds\n" +
            "notes: " +
            "${data['notes']}",
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ));
  }

  Widget _BottleEntry(Map data) {
    return Text(
        "Date: " +
            "${data['date']}\n" +
            "Amount: " +
            "${data['amount']}\n" +
            "notes: " +
            "${data['notes']}",
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ));
  }

  Widget _FoodEntry(Map data) {
    return Text(
        "Date: " +
            "${data['date']}\n" +
            "food type: " +
            "${data['food type']}\n" +
            "Amount: " +
            "${data['amount']}\n"+
                "notes: " +
            "${data['notes']}",
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ));
  }
}
