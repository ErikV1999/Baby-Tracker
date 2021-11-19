import 'package:baby_tracker/models/feedingChartData.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/FeedingStats.dart';
import 'package:intl/intl.dart';

class FeedingEntries extends StatefulWidget {
  final String baby;

  const FeedingEntries({Key? key, required this.baby}) : super(key: key);
  @override
  _FeedingEntriesState createState() => _FeedingEntriesState();
}

class _FeedingEntriesState extends State<FeedingEntries> {

  String date = '';
  DateFormat formatter = DateFormat('MM-dd-yyyy');

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
    DateTime date = data['date'].toDate();
    return Text(
        "Date: " +
            "${date.month}-${date.day}-${date.year}\n" +
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
    DateTime date = data['date'].toDate();
    return Text(
        "Date: " +
            "${date.month}-${date.day}-${date.year}\n" +
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
    DateTime date = data['date'].toDate();
    return Text(
        "Date: " +
            "${date.month}-${date.day}-${date.year}\n" +
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
