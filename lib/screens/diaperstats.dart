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
  @override
  void initState()
    {
      super.initState();
      generateData();
    }
  //final locationCollection = FirebaseFirestore.instance.collection("diaper change");

  /*Future<void> getData() async{
    var collection = FirebaseFirestore.instance.collection('diaper change');
    var docSnapshot = await collection.doc('doc_id').get();
    Map<String, dynamic>? data = docSnapshot.data();
  }*/

  List<List<double>> datalisto = [
    [1, 2],
    [2, 2],
    [3, 1],
    [4, 4],
  ];
  /*List<DateTime> datatiempo= [];
  List<String> datastatus = [];*/
  List<diaperChange> myList = [];

  Future<void> generateData() async{
    Query _sleepRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change').orderBy("date", descending: true);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _sleepRef2.get();


    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    //print(dayArr[0]);
    print("PRINTING SNAPSHOT");
    //datalisto.clear();
    querySnapshot.docs.forEach((doc) {
      final Timestamp timestop = doc['date'];
      final DateTime date = timestop.toDate();
      for(int i = 0; i < myList.length; i++) {
        //datatiempo[i].(timestop);
        diaperChange newdiaperc = new diaperChange(date, doc['status'],);
        myList.add(newdiaperc);
      }
      print(date.day);
      print("Status of " + doc["status"]);
    });
    //print(allData.toString());
    //print(querySnapshot.docs);
    print(myList);
    print("AFTER PRINT");
  }


  
  Widget build(BuildContext context) {
    Query sleepRef = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change').orderBy("indexDate", descending: true);
    CollectionReference _sleepRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change');
    String babyPath = widget.baby;
    return Scaffold(
      appBar: AppBar(
      title: Text("Diaper Change Graph"),
      backgroundColor: Colors.cyanAccent,
      ),
      /*body: FutureBuilder<QuerySnapshot>(
        future: _sleepRef2.get(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            generateData();
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
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
                          Text("Notes: " "${data['Notes']}, " +
                              "date:" + "${data['date']}," +
                              "Status:" + "${data['status']},",
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
            //Text("Hi");
          }else{
            return Center(child: Text('Loading'));
          }
      },
      ),*/

    );
  }
}
