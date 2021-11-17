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
  Widget build(context){
    return StreamBuilder<dynamic>(
        stream: FirebaseFirestore.instance.doc(widget.baby).collection('weights').snapshots(),
        builder: (context, snapshot){
          return screen(context, snapshot);
        }
    );
  }
  Widget screen(context, snapshot){
    if(!snapshot.hasData)
      return Text("No Weight data");
    if(snapshot.data.docs == null)
      return Text("No Weight data");
    return ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (context, index){
          return buildWeightEntry(context, snapshot.data.docs[index]);
        }
    );
  }
  Widget buildWeightEntry(context, DocumentSnapshot documentSnapshot){
    Timestamp date = Timestamp.now();
    String notes = "";
    int weight = 0;

    try{
      date = documentSnapshot['time'];
      notes = documentSnapshot['notes'];
      weight = documentSnapshot['weight'];

    } on StateError catch(e){
      return Text("Malformed");
    }
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
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