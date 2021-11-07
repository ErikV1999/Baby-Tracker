import 'package:baby_tracker/screens/feeding.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/AllStats.dart';
import 'package:baby_tracker/screens/FeedingEntries.dart';
import 'package:baby_tracker/screens/FeedingGraph.dart';

class FeedingStats extends StatefulWidget {
  final String baby;

  const FeedingStats({Key? key, required this.baby}) : super(key: key);
  @override
  _FeedingStatsState createState() => _FeedingStatsState();
}

class _FeedingStatsState extends State<FeedingStats> {
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
            FeedingEntries(baby: babyPath),
            FeedingGraphs(),
          ],
        ),
      ),
    );
  }
}
