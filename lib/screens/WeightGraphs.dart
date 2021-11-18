import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightGraphs extends StatefulWidget{

  final String baby;      //stores the babies path
  final bool weight;
  //final String userEntry; //stores the doc ID of teh user
  WeightGraphs({Key? key, required this.baby, required this.weight,}) : super(key: key);

  @override
  State<WeightGraphs> createState() => _WeightGraphsState();
}

class _WeightGraphsState extends State<WeightGraphs> {
  Widget build(context){
    CollectionReference weightOrHeight;
    if(widget.weight == true)
      weightOrHeight = FirebaseFirestore.instance.doc(widget.baby).collection('weights');
    else
      weightOrHeight = FirebaseFirestore.instance.doc(widget.baby).collection('heights');

    return StreamBuilder(
      stream: weightOrHeight.snapshots(),
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
    double yx = 130;
    double yn = 0;
    bool yr = false;
    String xAxis = "Days";
    String yAxis = "Weight";

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
    if(mx > 365){
      xAxis = "Years";
      yr = true;
      mx = mx / 365;
    }
    var dataPoints;
    if (widget.weight == true) {
      dataPoints = List.generate(
        snapshot.data.docs.length,
          (i){
            double weight = snapshot.data.docs[i]['weight'].toDouble();
            double date = (snapshot.data.docs[i]['time'].millisecondsSinceEpoch.toDouble() - dob )/86400000;
            if(yr == true)
              date = date / 365;
            return FlSpot(date, weight);
          }

      );
    }
    else{
      yx = 7;
      yAxis = "Height";
      dataPoints = List.generate(
          snapshot.data.docs.length,
              (i){
            //double weight = snapshot.data.docs[i]['weight'].toDouble();
                double date = (snapshot.data.docs[i]['time'].millisecondsSinceEpoch.toDouble() - dob )/86400000;
                double feet = snapshot.data.docs[i]['feet'].toDouble();
                double inches = snapshot.data.docs[i]['inches'].toDouble();
                double totalHeight = inches + (feet * 12);
                totalHeight = totalHeight / 12;
                if(yr == true)
                  date = date / 365;

                return FlSpot(date, totalHeight);
          }

      );
    }


    return ListView(
      children: [
        Container(
          height: 200,
          child:
            LineChart(
              LineChartData(
                minX: mn,
                maxX: mx,
                minY: yn,
                maxY: yx,

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
                    leftTitle: AxisTitle(showTitle: true, titleText: yAxis, margin: 4),
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