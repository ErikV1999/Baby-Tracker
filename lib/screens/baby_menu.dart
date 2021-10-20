import 'package:baby_tracker/screens/diaperchange.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:baby_tracker/screens/Sleeping.dart';
import 'package:baby_tracker/screens/feeding.dart';
//import 'package:baby_tracker/screens/diaper.dart';

/*

Boilerplate code for the stateful widget.
constructor takes in a baby path from the main menu component
 */
class BabyMenu extends StatefulWidget{

  final String baby;    //will contain the babypath as  a string

  BabyMenu({Key? key, required this.baby}) : super(key: key);   //constructor requires baby path

  @override
  State<BabyMenu> createState() => _BabyMenuState();
}

/*
class is the "real" widget for BabyMenu due to the statefulness of the widget

 */
class _BabyMenuState extends State<BabyMenu> {
  dynamic babyName = "Placeholder";


  /*

    encapsulates the "screen" widget where all the visuals are actually built
   */
  Widget build(BuildContext context){   //build function only contains a stream builder
    String babyPath = widget.baby;      //gets baby path to create screen from
    return StreamBuilder(               //gets the babies data before creating screen
      stream: FirebaseFirestore.instance.doc(babyPath).snapshots(),   //gets the baby doc
      builder: (context, snapshot){
        if(!snapshot.hasData)           //if baby doc is gone
          return Text("Baby doesn't exist");
        return screen(context, snapshot);
      }
    );
  }
  /*

  Screen is encapsulated by the build function to make it easier to follow.
  Creates the screen widget which contains on the visuals created from the
  baby document.
   */
  Widget screen(BuildContext context,snapshot){
    String babyPath = widget.baby;    //gets the babies path to input into next component
    babyName = snapshot.data;
    return Scaffold(
      appBar: AppBar(
        title: Text(babyName["Name"]),    //ets the name from the snapshotdoc
        //title: Text(babyPath),
       /* title: StreamBuilder(
          stream: FirebaseFirestore.instance.doc(babyPath).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData)
              return Text("Jane Doe");
            dynamic babyName = snapshot.data;
            return Text(babyName["Name"]);
          }
        ),*/
        backgroundColor: Colors.cyanAccent,
      ),

      body: Column( //contains all the cards seen (5 cards)
        children: [
          Card(     //feeding card
            child: ListTile(
              title: Text("Feeding"),
              subtitle: Row(
                children: [
                  Text("Last Fed"),
                  Text("Fed"),
                  Text("Type")
                ]
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Feeding(baby: babyPath)),
                );
              }
            )
          ),
          Card(     //sleeping card
              child: ListTile(
                  title: Text("Sleeping"),
                  subtitle: Row(
                      children: [
                        Text("Last Sleep"),
                        Text("For")
                      ]
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)  =>  Sleeping(baby: babyPath)),
                    );
                  }
              )
          ),
          Card(     //diaper change card
              child: ListTile(
                  title: Text("Diaper Change"),
                  subtitle: Row(
                      children: [
                        Text("Last Changed"),
                        Text("Pooped"),
                        Text("Peed")
                      ]
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => diaperchange(baby: babyPath)),
                    );
                  }

              )
          ),
          Card(     //notes card
              child: ListTile(
                  title: Text("Notes"),
              )
          ),
          Card(     //all stats card
              child: ListTile(
                  title: Text("All Stats"),
              )
          ),

        ]
      ),
    );
  }
}


