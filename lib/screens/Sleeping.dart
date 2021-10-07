import 'package:flutter/material.dart';

class Sleeping extends StatefulWidget {
  const Sleeping({Key? key}) : super(key: key);

  @override
  _SleepingState createState() => _SleepingState();
}

class _SleepingState extends State<Sleeping> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white38,
        appBar: AppBar(
          title: Text('Sleeping'),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
    );
  }
}