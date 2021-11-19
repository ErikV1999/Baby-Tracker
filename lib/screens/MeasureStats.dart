import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:baby_tracker/screens/HeightEntries.dart';
import 'package:baby_tracker/screens/WeightEntries.dart';
import 'package:baby_tracker/screens/HeightGraphs.dart';
import 'package:baby_tracker/screens/WeightGraphs.dart';

class MeasureStats extends StatefulWidget{

  final String baby;      //stores the babies path
  //final String userEntry; //stores the doc ID of teh user
  MeasureStats({Key? key, required this.baby}) : super(key: key);

  @override
  State<MeasureStats> createState() => _MeasureStatsState();
}

class _MeasureStatsState extends State<MeasureStats> {
  Widget build(context){
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Height Entries'),
              Tab(text: 'Weight Entries'),
              Tab(text: 'Height Graph'),
              Tab(text: 'Weight Graph'),
            ]
          ),
          title: Text("Height and Weight"),
          automaticallyImplyLeading: false,
        ),
        body: TabBarView(
          children: [
            HeightEntries(baby:widget.baby),
            WeightEntries(baby:widget.baby),
            WeightGraphs(baby:widget.baby, weight:false),
            WeightGraphs(baby: widget.baby, weight:true),
          ]
        )
      ),

    );
  }
}