import 'package:baby_tracker/models/Themes/theme_provider.dart';
import 'package:baby_tracker/screens/Milestones.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'notes.dart';

class AddNote extends StatefulWidget {
  final String baby;
  const AddNote({Key? key, required this.baby}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late String title = 'Title';
  late String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('New Note'),
       //backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 12, 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent),
              child: Text(
                  'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => add(),
            ),
          ),
        ],
      ),


      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  title = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Milestones())
                  );
                  setState(() {});
                },
                child: Container(
                  child: Text(
                      title,
                    style: TextStyle(fontSize: 34),
                  ),
                  color: Colors.blue,
                  width: double.infinity,
                ),
              ),
              Form(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.75,
                    padding: const EdgeInsets.all(12),
                    child: TextFormField(
                      decoration: InputDecoration.collapsed(
                        hintText: 'Note Description',
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 20,

                      onChanged: (val) {
                        description = val;
                      },
                    ),
                  ),
              )
            ],
          ),
        )
      ),
    );
  }
void add() async {
    CollectionReference notesRef = FirebaseFirestore.instance.doc(widget.baby).collection('notes');
    var data = {
      'title': title,
      'description': description,
      'timestamp': DateTime.now(),
    };

    notesRef.add(data);

    Navigator.pop(context);
}

}
