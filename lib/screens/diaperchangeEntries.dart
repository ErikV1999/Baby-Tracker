import 'package:baby_tracker/screens/diaperstats.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:baby_tracker/models/diaperchangechart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class diaperentries extends StatefulWidget {
  final String baby;
  const diaperentries({Key? key, required this.baby}) : super(key: key);

  @override
  _diaperentries createState() => _diaperentries();
}

class _diaperentries extends State<diaperentries> {

  @override

  Future<void> generateData() async{
    Query _diaperRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('diaper').orderBy("date", descending: true);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _diaperRef2.get();
    DateTime temp;


    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    querySnapshot.docs.forEach((doc) {
        print(doc["date"]);
      });
  }

  Widget build(BuildContext context) {
    //get data from database
    Query diaperRef = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change').orderBy("date", descending: true);
    CollectionReference _diaperRef2 = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change');
    String babyPath = widget.baby;

    return Scaffold(
      appBar: AppBar(
        //title: Text(babyPath),
        title: Text(
          'Diaper Change Entries',
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
        future: diaperRef.get(),
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
                          /*Text(
                            "${data['Notes']}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),*/
                          Text("Date: " "${data['date']}, \n" +
                              "Status of diaper:" + "${data['status']},\n" +
                              "Notes: " + "${data['Notes']},",
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
          } else {
            return Center(child: Text('Loading...'));
          }
        },
      ),
    );
  }
}

