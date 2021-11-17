import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightGraphs extends StatefulWidget{

  final String baby;      //stores the babies path
  //final String userEntry; //stores the doc ID of teh user
  WeightGraphs({Key? key, required this.baby}) : super(key: key);

  @override
  State<WeightGraphs> createState() => _WeightGraphsState();
}

class _WeightGraphsState extends State<WeightGraphs> {
  Widget build(context){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.doc(widget.baby).collection('weights').snapshots(),
      builder: (context, snapshot){
        return buildWithBaby(context, snapshot);
      }
    );
  }
  Widget buildWithBaby(context, snapshot){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.doc(widget.baby).snapshots(),
      builder: (context, snapshotBuilder){
        return Padding(
          padding: EdgeInsets.fromLTRB(0,20.0,0,0),
          child: screen(context, snapshot, snapshotBuilder),
        );


      }
    );
  }
  Widget screen(context,snapshot, snapshotBaby){

    double dob = DateTime.now().millisecondsSinceEpoch.toDouble();
    double mx = 0;
    double mn = 0;
    bool yr = false;
    String xAxis = "Days";

    if(!snapshot.hasData)
      return Text("No Weight data");
    if(snapshot.data.docs == null)
      return Text("No Weight data");

    if(!snapshotBaby.hasData)
      return Text("No baby data");

    try{
      dob = snapshotBaby.data['dob'].toDouble();
    } on StateError catch(e){
      return Text("Malformed baby dob");
    }

    mx = DateTime.now().millisecondsSinceEpoch.toDouble() - dob;
    mx = mx / 86400000;
    if(mx > 360){
      xAxis = "Years";
      yr = true;
      mx = mx / 365;
    }

    var dataPoints = List.generate(
      snapshot.data.docs.length,
        (i){
          double weight = snapshot.data.docs[i]['weight'].toDouble();
          double date = (snapshot.data.docs[i]['time'].millisecondsSinceEpoch.toDouble() - dob )/86400000;
          if(yr == true)
            date = date / 365;
          return FlSpot(date, weight);
        }

    );



    return ListView(
      children: [
        Container(
          height: 200,
          child:
            LineChart(
              LineChartData(
                minX: mn,
                maxX: mx,
                minY: 0,
                maxY: 120,

                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (val) {
                    return FlLine(
                      strokeWidth: 1,
                      color: Colors.black,
                    );
                  },

                ),
                  axisTitleData: FlAxisTitleData(
                    leftTitle: AxisTitle(showTitle: true, titleText: 'Weight', margin: 4),
                    bottomTitle: AxisTitle(showTitle: true, titleText: xAxis, margin: 4)
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: dataPoints,
                    isCurved: true,
                    barWidth: 5,

                  ),


                ]
              )
            )
        )
      ]
    );
  }
}