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
    return Text("hi");
  }
}