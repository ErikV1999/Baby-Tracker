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
  /*
  creates a stream based on the heights subcollection
   */
  Widget build(context){
    return StreamBuilder<dynamic>(
      stream: FirebaseFirestore.instance.doc(widget.baby).collection('heights').snapshots(),
      builder: (context, snapshot){
        return screen(context, snapshot);
      }
    );
  }
  /*
  display the screen after fetching the most recent data in the stream
   */
  Widget screen(context, snapshot){
    /*
    check that stream data exists
     */
    if(!snapshot.hasData)
      return Text("No Height data");
    if(snapshot.data.docs == null)
      return Text("No Height data");
    //generate all the cards as a listview
    return ListView.builder(
      itemCount: snapshot.data.docs.length,
      itemBuilder: (context, index){
        return buildHeightEntry(context, snapshot.data.docs[index]);
      }
    );
  }
  /*
  creates each individual card from the database data
   */
  Widget buildHeightEntry(context, DocumentSnapshot documentSnapshot){
    Timestamp date = Timestamp.now(); //contains the date from teh db entry
    String notes = "";                //contains the notes form the db entry
    int inches = 0;                   //contains the inches from teh db entry
    int feet = 0;                      //contains the feet from the db entry
    /*
    attempt to pull data from teh database snapshot
     */
    try{
      date = documentSnapshot['time'];
      notes = documentSnapshot['notes'];
      inches = documentSnapshot['inches'];
      feet = documentSnapshot['feet'];

    } on StateError catch(e){
      return Text("Malformed");
    }
    //convert from epoch time to a datetime so it can be used aas a string
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