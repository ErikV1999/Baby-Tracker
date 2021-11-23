import 'package:baby_tracker/models/Themes/changeTheme.dart';
import 'package:baby_tracker/models/Themes/theme_provider.dart';
import 'package:baby_tracker/screens/diaperchange.dart';
import 'package:baby_tracker/screens/notes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:baby_tracker/screens/Sleeping.dart';
import 'package:baby_tracker/screens/feeding.dart';
import 'package:baby_tracker/screens/add_caretaker.dart';
import 'package:baby_tracker/screens/AllStats.dart';
import 'package:baby_tracker/screens/debugPage.dart';
import 'package:baby_tracker/screens/emergency.dart';
import 'package:baby_tracker/screens/measure.dart';
//import 'package:baby_tracker/screens/diaper.dart';


/*

Boilerplate code for the stateful widget.
constructor takes in a baby path from the main menu component
 */
class BabyMenu extends StatefulWidget{

  final String baby;    //will contain the babypath as  a string
  final String userEntry;
  BabyMenu({Key? key, required this.baby, required this.userEntry}) : super(key: key);   //constructor requires baby path

  @override
  State<BabyMenu> createState() => _BabyMenuState();
}

/*
class is the "real" widget for BabyMenu due to the statefulness of the widget

 */
class _BabyMenuState extends State<BabyMenu> {
  dynamic baby = "Placeholder";


  void addCaretakerClick(){

  }

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
    baby = snapshot.data;             //contains the document of the baby from the db
    Color bannerColor = Color(0xFF006992);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(baby["Name"]),    //ets the name from the snapshotdoc
        actions: <Widget>[      //sign out button at the appbar
          TextButton(

            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Emergency(baby: babyPath, userEntry: widget.userEntry)),
              );

            },
            child: Text('EMERGENCY', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),

          ),
          ChangeThemeButton(),
        ],
      ),

      body: ListView( //contains all the cards seen (5 cards)
        children: [
          Card(     //feeding card
            color: MyThemes.kobiPink,
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
              color: Theme.of(context).primaryColor,
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
          Card(     //diaper change card, if clicked takes user to page to input data on diaper change of baby
              color: MyThemes.kobiPink,
              child: ListTile(
                  title: Text("Diaper Change"),
                  subtitle: Row(
                      children: [
                        Text("Enter diaper change data for "),
                        Text(baby["Name"]),
                      ]
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      //take user to diaper change page
                      MaterialPageRoute(builder: (context) => diaperchange(baby: babyPath)),
                    );
                  }

              )
          ),
          Card(     //diaper change card
              color: Theme.of(context).primaryColor,
              child: ListTile(
                  title: Text("Height and Weight"),
                  subtitle: Row(
                      children: [
                        //Text("Last Changed"),
                        //Text("Pooped"),
                        //Text("Peed")
                      ]
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Measure(baby: babyPath, userEntry:widget.userEntry)),
                    );
                  }

              )
          ),
          Card(     //notes card
            color: MyThemes.kobiPink,
            child: ListTile(
                title: Text("Notes"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notes(baby: babyPath)),
                  );
                },
              ),
          ),
          Card(     //diaper change card
            color:Theme.of(context).primaryColor,
            child: ListTile(
                title: Text("All Stats"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllStats(baby: babyPath)),
                  );
                },
              ),
          ),
          Card(
            color: MyThemes.kobiPink,
            child: ListTile(
              title: Text("Add Caretakers"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCaretaker(baby: babyPath, userEntry: widget.userEntry, babyDoc: baby)),
                );
              }
            )
          ),
        ]
      ),
    );
  }
}
