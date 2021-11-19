import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HeightEntries extends StatefulWidget{

  final String baby;      //stores the babies path
  //final String userEntry; //stores the doc ID of teh user
  HeightEntries({Key? key, required this.baby}) : super(key: key);

  @override
  State<HeightEntries> createState() => _HeightEntriesState();
}

class _HeightEntriesState extends State<HeightEntries> {
  Widget build(context){
    return StreamBuilder<dynamic>(
      stream: FirebaseFirestore.instance.doc(widget.baby).collection('heights').snapshots(),
      builder: (context, snapshot){
        return screen(context, snapshot);
      }
    );
  }
  Widget screen(context, snapshot){
    if(!snapshot.hasData)
      return Text("No Height data");
    if(snapshot.data.docs == null)
      return Text("No Height data");
    return ListView.builder(
      itemCount: snapshot.data.docs.length,
      itemBuilder: (context, index){
        return buildHeightEntry(context, snapshot.data.docs[index]);
      }
    );
  }
  Widget buildHeightEntry(context, DocumentSnapshot documentSnapshot){
    Timestamp date = Timestamp.now();
    String notes = "";
    int inches = 0;
    int feet = 0;
    try{
      date = documentSnapshot['time'];
      notes = documentSnapshot['notes'];
      inches = documentSnapshot['inches'];
      feet = documentSnapshot['feet'];

    } on StateError catch(e){
      return Text("Malformed");
    }
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
      return Card(
      child: ListTile(
        title: Text(dateTime.year.toString() + " - " + dateTime.month.toString() + " - " + dateTime.day.toString()),
        subtitle: Column(
          children: [
            Text(feet.toString() + " ft " + inches.toString() + " in "),
            Text(notes),
          ]
        )
      )
    );
  }
}