import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightGraphs extends StatefulWidget{

  final String baby;      //stores the babies path
  final bool weight;      //determines if this graph will display weight or height: true if weight
  //final String userEntry; //stores the doc ID of teh user
  WeightGraphs({Key? key, required this.baby, required this.weight,}) : super(key: key);

  @override
  State<WeightGraphs> createState() => _WeightGraphsState();
}
/*
This component creates teh weight graph but was also mashed into also being the
height graph because most of the code wouldve just been copy pasted.
 */
class _WeightGraphsState extends State<WeightGraphs> {

  /*
  gets a stream of either the height or weight collection
   */
  Widget build(context){

    /*
    determine if the graph is weight or height and use that reference
     */
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
  /*
  gets a stream of the baby doc and comes in with either height or weight stream already created
   */
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
  /*
  this is created with teh previous two streams already established. This then generates
  the screen.
   */
  Widget screen(context,snapshot, snapshotBaby){

    double dob = DateTime.now().millisecondsSinceEpoch.toDouble();
    double mx = 0;      //maximum x value
    double mn = 0;      //minimum x value
    double yx = 130;    //maximum y value
    double yn = 0;      //minimum y value
    bool yr = false;    //tells teh whole screen if the axis is going by year instead of day
    String xAxis = "Days";    //string for the x axis, default in days
    String yAxis = "Weight";    //y axis, default for weight graph but could be height
    var dataPoints;     //datapoints that will be generated from teh database data

    /*
    checks to make sure all the snapshot actually have data
     */
    if(!snapshot.hasData)
      return Text("No Weight data");
    if(snapshot.data.docs == null)
      return Text("No Weight data");

    if(!snapshotBaby.hasData)
      return Text("No baby data");

    /*
    attempt to pull the date of birth
     */
    try{
      dob = snapshotBaby.data['dob'].toDouble();
    } on StateError catch(e){
      return Text("Malformed baby dob");
    }

    /*
    set teh x axis based on the babies date of birth and teh current time.
    This is true even if its height or weight.
     */
    mx = DateTime.now().millisecondsSinceEpoch.toDouble() - dob;
    mx = mx / 86400000;
    if(mx > 365){       //if setting to years mode
      xAxis = "Years";
      yr = true;
      mx = mx / 365;
    }

    /*
    if the graph is supposed to be based on weight, this is used to generate the
    points
     */

    if (widget.weight == true) {
      dataPoints = List.generate(
        snapshot.data.docs.length,
          (i){
            double weight = snapshot.data.docs[i]['weight'].toDouble();       //pulls the weight from the database and sets it to a double
            /*
            date is created by pulling the timestamp in the database for the post,
            converting it to miliseconds since the epoch,
            subtracting the date of birth(already in epoch time)
            and dividing by the milliseconds in a day
            This gives the days since the dob birth
             */
            double date = (snapshot.data.docs[i]['time'].millisecondsSinceEpoch.toDouble() - dob )/86400000;
            if(yr == true)  //if yr is set to true, divide by the number of days in a year to compensate
              date = date / 365;
            return FlSpot(date, weight);
          }

      );
    }
    /*
    this is used to generate the graph if the bool is set to false. This means the
    height graph should be generated
     */
    else{
      yx = 7;             //sets the y to 7, hardcoded assuming babies cant be over 7 feet
      yAxis = "Height";   //sets y axis
      dataPoints = List.generate(
          snapshot.data.docs.length,
              (i){
                /*
                see last explanation of date, its the same
                 */
                double date = (snapshot.data.docs[i]['time'].millisecondsSinceEpoch.toDouble() - dob )/86400000;
                double feet = snapshot.data.docs[i]['feet'].toDouble();     //pull feet from db
                double inches = snapshot.data.docs[i]['inches'].toDouble(); //pull inches from db
                double totalHeight = inches + (feet * 12);                   //convert it all to inches
                totalHeight = totalHeight / 12;                              //then divide by 12 to bring it all back to feet
                //if yr, x axis should be in year, so compensate the x value on the point
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