import 'package:baby_tracker/screens/diaperchangeEntries.dart';
import 'package:baby_tracker/screens/diaperchangeGraph.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/FeedingEntries.dart';
import 'package:baby_tracker/screens/FeedingGraph.dart';

class DiaperStats extends StatefulWidget {
  final String baby;

  const DiaperStats({Key? key, required this.baby}) : super(key: key);
  @override
  _DiaperStatsState createState() => _DiaperStatsState();
}

class _DiaperStatsState extends State<DiaperStats> {
  @override
  Widget build(BuildContext context) {
    String babyPath = widget.baby;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.orangeAccent,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(child: Container()),
                  TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.format_align_left)),
                      Tab(icon: Icon(Icons.show_chart)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            diaperentries(baby: babyPath),
            diapergraph(baby: babyPath),
          ],
        ),
      ),
    );
  }
}
