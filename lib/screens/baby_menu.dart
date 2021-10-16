import 'package:baby_tracker/screens/diaperchange.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:baby_tracker/screens/Sleeping.dart';
import 'package:baby_tracker/screens/feeding.dart';
//import 'package:baby_tracker/screens/diaper.dart';
class BabyMenu extends StatefulWidget{

  final String baby;

  BabyMenu({Key? key, required this.baby}) : super(key: key);

  @override
  State<BabyMenu> createState() => _BabyMenuState();
}



class _BabyMenuState extends State<BabyMenu> {
  dynamic babyName = "Placeholder";

  Widget build(BuildContext context){
    dynamic babyPath = widget.baby;

    return Scaffold(
      appBar: AppBar(
        title: Text(babyPath),
        backgroundColor: Colors.cyanAccent,
      ),
      body: Column(
        children: [
          Card(
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
                  MaterialPageRoute(builder: (context) => const Feeding()),
                );
              }
            )
          ),
          Card(
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
                      MaterialPageRoute(builder: (context) => const Sleeping()),
                    );
                  }
              )
          ),
          Card(
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
                      MaterialPageRoute(builder: (context) => const diaperchange()),
                    );
                  }

              )
          ),
          Card(
              child: ListTile(
                  title: Text("Notes"),
              )
          ),
          Card(
              child: ListTile(
                  title: Text("All Stats"),
              )
          ),

        ]
      ),
    );
  }
}


