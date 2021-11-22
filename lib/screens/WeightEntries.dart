import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WeightEntries extends StatefulWidget{

  final String baby;      //stores the babies path
  //final String userEntry; //stores the doc ID of teh user
  WeightEntries({Key? key, required this.baby}) : super(key: key);

  @override
  State<WeightEntries> createState() => _WeightEntriesState();
}

class _WeightEntriesState extends State<WeightEntries> {
  /*
  builds a stream with the weights subcollection
   */
  Widget build(context){
    return StreamBuilder<dynamic>(
        stream: FirebaseFirestore.instance.doc(widget.baby).collection('weights').snapshots(),
        builder: (context, snapshot){
          return screen(context, snapshot);
        }
    );
  }
  /*
  screen that gets displayed, already has teh weights collection
   */
  Widget screen(context, snapshot){
    if(!snapshot.hasData)
      return Text("No Weight data");
    if(snapshot.data.docs == null)
      return Text("No Weight data");
    /*
    creates each individual item in the list
     */
    return ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (context, index){
          return buildWeightEntry(context, snapshot.data.docs[index]);
        }
    );
  }
  /*
  build weight entry creates a card for a listview that is created based on an
  entry in the database
   */
  Widget buildWeightEntry(context, DocumentSnapshot documentSnapshot){
    Timestamp date = Timestamp.now();     //the date that will be displayed on the card
    String notes = "";      //notes section from the entry
    int weight = 0;         //wegith of this entry

    /*
    attempt to pull data from teh entry.
     */
    try{
      date = documentSnapshot['time'];
      notes = documentSnapshot['notes'];
      weight = documentSnapshot['weight'];

    } on StateError catch(e){
      return Text("Malformed");
    }

    /*
    convert the date from epoch time to a date time to use as a string.

     */
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
    /*
    create the card with all the data pulled from the entry
     */
    return Card(
        child: ListTile(
            title: Text(dateTime.year.toString() + " - " + dateTime.month.toString() + " - " + dateTime.day.toString()),
            subtitle: Column(
                children: [
                  Text(weight.toString() + " lbs " ),
                  Text(notes),
                ]
            )
        )
    );
  }
}