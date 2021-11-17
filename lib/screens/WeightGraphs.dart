import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WeightGraphs extends StatefulWidget{

  final String baby;      //stores the babies path
  //final String userEntry; //stores the doc ID of teh user
  WeightGraphs({Key? key, required this.baby}) : super(key: key);

  @override
  State<WeightGraphs> createState() => _WeightGraphsState();
}

class _WeightGraphsState extends State<WeightGraphs> {
  Widget build(context){
    return Text("hi");
  }
}