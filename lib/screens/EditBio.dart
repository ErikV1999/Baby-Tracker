import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBio extends StatefulWidget{

  final String baby;
  final String userEntry;
  final String bio;
  EditBio({Key? key, required this.baby, required this.userEntry, required this.bio}) : super(key: key);

  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {

  TextEditingController bio = TextEditingController();

  @override
  void initState() {
    bio = TextEditingController(text: widget.bio);
    super.initState();
  }

  void updateBio () async{
    FirebaseFirestore.instance.doc(widget.baby).update({
      'emergency' : bio.text,
    }).whenComplete(()=>Navigator.pop(context));
  }

  Widget build(context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Emergency Info'),
        //backgroundColor: Colors.amber,
        actions: [
          Container(
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
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            child:TextFormField(
              controller: bio,
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

  Widget buildBio(snapshot){
    return Text("Im going to bed");
  }
}