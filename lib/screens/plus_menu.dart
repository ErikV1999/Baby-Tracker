
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/addbaby.dart';
import 'package:baby_tracker/screens/invites.dart';

class PlusMenu extends StatefulWidget{
  final String user;
  const PlusMenu({Key? key, required this.user});

  @override
  State<PlusMenu> createState() => _PlusMenuState();
}

class _PlusMenuState extends State<PlusMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(),
      body: ListView(
        children: [
          ElevatedButton(
            child: Text("Add Baby"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBaby(userEntry:widget.user)),
              );
            }
          ),
          ElevatedButton(
              child: Text("Invites"),
              onPressed:() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Invites(user:widget.user)),
                );
              }
          )
        ]
      ),
    );

  }
}