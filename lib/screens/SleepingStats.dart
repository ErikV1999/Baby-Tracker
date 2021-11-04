import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/AllStats.dart';
import 'package:baby_tracker/screens/SleepingEntries.dart';
import 'package:baby_tracker/screens/SleepingGraphs.dart';

class SleepingStats extends StatefulWidget {

  @override
  _SleepingStatsState createState() => _SleepingStatsState();
}
/*
class _SleepingStatsState extends State<SleepingStats> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text('View Past Sleeping Entries'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SleepingEntries()),
                );
              }
            ),
          ),
          Card(
            child: ListTile(
                title: Text('View Sleeping Graphs'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SleepingGraphs()),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
*/
class _SleepingStatsState extends State<SleepingStats> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                  'Sleeping',
              style: TextStyle(),
              textAlign: TextAlign.end,
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.format_align_left)),
                  Tab(icon: Icon(Icons.show_chart)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                SleepingEntries(),
                SleepingGraphs(),
              ],
            ),
          )
      ),
    );
  }
}