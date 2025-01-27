import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Measure extends StatefulWidget{

  final String baby;      //stores the babies path
  final String userEntry; //stores the doc ID of teh user
  Measure({Key? key, required this.baby, required this.userEntry}) : super(key: key);

  @override
  State<Measure> createState() => _MeasureState();
}

class _MeasureState extends State<Measure> {

  final formKey = GlobalKey<FormState>();     //key for the form to be validated
  int weight = 0;                             //weight is the internal storage of the weight input
  int feet = 0;                               //internal storage of the feet input
  int inches = 0;                             //internal storage of the inches input
  String notes = "";                          //stores the notes until it upload

  DateTime selectedDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch  );

/*
build function required for statefulwidget implementation

context: required parameter boilerplate
 */
  Widget build(context){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.doc(widget.baby).snapshots(),
      builder: (context, snapshot){
        return screen(context,snapshot);
      }
    );
  }
  Widget screen(context, snapshot){
    if(!snapshot.hasData)
      return Text("No baby data");
    if(snapshot.data == null)
      return Text("No baby data");

    var baby = snapshot.data;
    DateTime dob = DateTime.fromMillisecondsSinceEpoch(baby['dob']);
    //DateTime dob = DateTime.fromMillisecondsSinceEpoch(snapshot.data['dob'] );
    //if(snapshot.data['dob'] > DateTime.now().millisecondsSinceEpoch){
    if(baby['dob'] > DateTime.now().millisecondsSinceEpoch){
      return Scaffold(
        appBar: AppBar(),
        body: Text("Baby isn't born yet"),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Height and Weight")
      ),
      body: Container(
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                height: 200,
                child: CupertinoDatePicker(
                  onDateTimeChanged: (val){
                    selectedDate = val;
                  },
                  initialDateTime: DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: dob,
                  maximumDate: DateTime.now(),
                ),
              ),
              Text(
                "Can only enter dates between Date of Birth and current time"
              ),
              SizedBox(height: 60.0),
              Row(
                  children:[
                    Text("Weight: "),
                    Expanded(
                        child: buildWeight()
                    ),
                  ]
              ),
              SizedBox(height: 60.0),
              //buildSubmitWeight(),
              //SizedBox(height: 60.0),
              buildHeight(),
              SizedBox(height: 60.0),
              Row(
                  children:[
                    Text("Notes: "),
                    Expanded(
                      child: buildNotes()
                    )
                  ]
              ),
              SizedBox(height: 20.0),
              buildSubmitHeight(),
              SizedBox(height: 60.0),

            ]
          )
        ),
      ),

    );
  }
  /*
  buildWeight() builds the weight input text form for the user to input weight

  no parameters

  returns the textformfield
   */
  Widget buildWeight(){
    //return Text("Hello");
    return TextFormField(
      decoration: InputDecoration(
        //labelText: 'Weight: ',

      ),
      validator: (val){
        if(val!.isEmpty)
          return 'Enter value: weight';
        dynamic isInt = int.tryParse(val);
        if(isInt == null)
          return 'Enter a valid Integer';
      },
      onChanged: (val){
        setState(() {
          weight = int.parse(val);
        });
      },
    );
  }
/*
buildHeight() is a combination of texts widgets that add context like "height" "ft" "inches"
and 2 textformfields for the input of ft and inches

takes no parameters

returns the row of widgets
 */
  Widget buildHeight(){
    return Row(
      children: [
        Text("Height: "),
        Expanded(
          child: TextFormField(
            validator: (val){
              if(val!.isEmpty)
                return 'Enter value: feet';
              dynamic isInt = int.tryParse(val);
              if(isInt == null)
                return 'Enter a valid Integer';
              if(int.parse(val) > 5)
                return 'can\'t enter a height above 5\' 11\"';
            },
            onChanged: (val){
              setState(() {
                feet = int.parse(val);
              });
            },
          ),
        ),
        Text("ft "),
        Expanded(
          child: TextFormField(
            validator: (val){
              if(val!.isEmpty)
                return 'Enter value: inches';
              dynamic number = int.tryParse(val);
              if(number == null)
                return 'Enter a valid Integer';
              if(number <0 || number > 11)
                return 'Enter number 0-11';

            },
            onChanged: (val){
              setState(() {
                inches = int.parse(val);
              });
            },
          ),
        ),
        Text("in"),
      ]
    );
    return Text("Hello");
  }
  /*
  buildNotes() creates a text form field to input notes to go along with the update

  takes no parameters

  returns the textformfield()
   */
  Widget buildNotes(){
    return TextFormField(
      validator: (val){},
      onChanged: (val){
        setState((){
          notes = val.toString();
        });
      },

    );
  }
  /*
  buildSubmitHeight() is a button that validates all the form fields when its pressed
  and then adds all the data to teh firebase firestore. height is one collection and w
  weight is another collectino. The baby's doc is also updated with teh height and weight.

  no parameter

  returns a widget of a button
   */
  Widget buildSubmitHeight(){
    return ElevatedButton(
      child: Text("Submit"),
      onPressed: (){
        if(formKey.currentState!.validate()){                           //all fields are valid
          CollectionReference weights = FirebaseFirestore.instance      //add a new entry to the weights collection in the baby
              .doc(widget.baby)
              .collection('weights');
          CollectionReference heights = FirebaseFirestore.instance    //add a new entry to the heights collection in the baby
              .doc(widget.baby)
              .collection('heights');
          DocumentReference baby = FirebaseFirestore.instance         //udates the baby doc with the current height and weight
              .doc(widget.baby);

          //weights.add({
          weights.doc(selectedDate.year.toString()+selectedDate.month.toString()+selectedDate.day.toString()).set({
            'weight' : weight,
            'notes' : notes,
            'time' : selectedDate,

          });
          heights.doc(selectedDate.year.toString()+selectedDate.month.toString()+selectedDate.day.toString()).set({
            'feet' : feet,
            'inches' : inches,
            'notes' : notes,
            'time' : selectedDate,
          });
          baby.update({
            'inches' : inches,
            'feet' : feet,
            'notes' : notes,
            'weight' : weight,
          });
          Navigator.pop(
            context,

          );
        }
      }
    );
  }
}