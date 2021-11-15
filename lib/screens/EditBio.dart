import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBio extends StatefulWidget{

  final String baby;    //babies path
  final String userEntry;   //users doc ID
  final String bio;     //bio or emergency info being passed
  EditBio({Key? key, required this.baby, required this.userEntry, required this.bio}) : super(key: key);

  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {

  TextEditingController info = TextEditingController();   //controlls the form text field
/*
creates an initial state of the function with the babies info already used as the
text field to start
 */
  @override
  void initState() {          //sets the inital text form field to being what ever the baby had
    info = TextEditingController(text: widget.bio);
    super.initState();
  }
/*
updates the emergency info in the firestore database

takes no parameters

returns nothign
 */
  void updateBio () async{    //updates the babies value to what ever the user inputs into the field
    FirebaseFirestore.instance.doc(widget.baby).update({
      'emergency' : info.text,
    }).whenComplete(()=>Navigator.pop(context));    //go back to babies emergency page
  }
/*
standard build function required

context: build context boilerplate
 */
  Widget build(context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Emergency Info'),   //title on bar
        //backgroundColor: Colors.amber,
        actions: [
          Container(      //contains the save button on the bar
            padding: EdgeInsets.fromLTRB(0, 10, 12, 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => updateBio(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(    //contains the form text field
        child: Container(
          child: Form(
            child:TextFormField(
              controller: info,
              maxLines: 20,
              decoration: InputDecoration.collapsed(
                hintText: 'Enter Emergency Information',
              ),
            )
          )
        )
      ),
    );
  }

  //Widget buildBio(snapshot){  //this is nothing
  //  return Text("Im going to bed");
 // }
}