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

  //final locationCollection = FirebaseFirestore.instance.collection("diaper change");

  /*Future<void> getData() async{
    var collection = FirebaseFirestore.instance.collection('diaper change');
    var docSnapshot = await collection.doc('doc_id').get();
    Map<String, dynamic>? data = docSnapshot.data();
  }*/

  
  Widget build(BuildContext context) {
    String babyPath = widget.baby;
    return Scaffold(
      appBar: AppBar(
      title: Text("Diaper Change Graph"),
      backgroundColor: Colors.cyanAccent,
      ),
      body: Text("Hi"),
    );
  }
}
