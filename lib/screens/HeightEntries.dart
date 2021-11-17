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
    return Text("hi");
  }
}