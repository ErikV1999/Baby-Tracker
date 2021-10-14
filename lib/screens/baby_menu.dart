import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:baby_tracker/screens/Sleeping.dart';
import 'package:baby_tracker/screens/feeding.dart';
//import 'package:baby_tracker/screens/diaper.dart';
class BabyMenu extends StatefulWidget{
  @override
  State<BabyMenu> createState() => _BabyMenuState();
}



class _BabyMenuState extends State<BabyMenu> {
  dynamic babyName = "Placeholder";
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(babyName),
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
                  /*onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Diaper()),
                    );
                  }*/

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


