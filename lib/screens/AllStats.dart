import 'package:baby_tracker/screens/diaperchange.dart';
import 'package:baby_tracker/screens/diaperstats.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/SleepingStats.dart';
import 'package:baby_tracker/screens/FeedingStats.dart';


class AllStats extends StatefulWidget {

  final String baby;

  const AllStats({Key? key, required this.baby}) : super(key: key);
  @override
  _AllStatsState createState() => _AllStatsState();
}

class _AllStatsState extends State<AllStats> {

  @override
  Widget build(BuildContext context) {
    String babyPath = widget.baby;
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.fastfood_sharp)),
                Tab(icon: Icon(Icons.access_time_outlined)),
                Tab(icon: Icon(Icons.baby_changing_station)),
              ],
            ),
            title: const Text('All Stats'),
          ),
          body: TabBarView(
            children: [
              FeedingStats(baby: babyPath),
              SleepingStats(baby: babyPath),
              diaperstats(),
            ],
          ),
        )
      ),
    );
  }
}