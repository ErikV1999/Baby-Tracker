import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/SleepingStats.dart';

class SleepingEntries extends StatefulWidget {

  @override
  _SleepingEntriesState createState() => _SleepingEntriesState();
}

class _SleepingEntriesState extends State<SleepingEntries> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('hi'),
      ),
    );
  }
}