import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HeightGraphs extends StatefulWidget{

  final String baby;      //stores the babies path
  //final String userEntry; //stores the doc ID of teh user
  HeightGraphs({Key? key, required this.baby}) : super(key: key);

  @override
  State<HeightGraphs> createState() => _HeightGraphsState();
}

class _HeightGraphsState extends State<HeightGraphs> {
  Widget build(context){
    return Text("hi");
  }
}