import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/AllStats.dart';
import 'package:baby_tracker/screens/SleepingEntries.dart';
import 'package:baby_tracker/screens/SleepingGraphs.dart';

class SleepingStats extends StatefulWidget {

  final String baby;

  const SleepingStats({Key? key, required this.baby}) : super(key: key);
  @override
  _SleepingStatsState createState() => _SleepingStatsState();
}
class _SleepingStatsState extends State<SleepingStats> {

  @override
  Widget build(BuildContext context) {
    String babyPath = widget.baby;
    return Scaffold(
      body: DefaultTabController(
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
                SleepingEntries(baby: babyPath),
                SleepingGraphs(baby: babyPath),
              ],
            ),
          )
      ),
    );
  }
}