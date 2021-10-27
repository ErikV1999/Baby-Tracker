import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final DocumentSnapshot document;

  const EditNote({Key? key, required this.document}) : super(key: key);

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    title = TextEditingController(text: widget.document['title']);
    description = TextEditingController(text: widget.document['description']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('New Note'),
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 12, 10),
            color: Colors.amber,
            child: ElevatedButton(
              child: Text('Save'),
              onPressed: () => {
                widget.document.reference.update({
                  'title': title.text,
                  'description': description.text,
                }).whenComplete(() => Navigator.pop(context)),
              },
            ),
          ),
        ],
      ),


      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Form(
                  child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration.collapsed(
                            hintText: 'Title',
                          ),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          controller: title,

                          onChanged: (val) {}
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height*0.75,
                          padding: const EdgeInsets.only(top: 12),
                          child: TextFormField(
                            decoration: InputDecoration.collapsed(
                              hintText: 'Note Description',
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            controller: description,
                            maxLines: 20,

                            onChanged: (val) {},
                          ),
                        ),
                      ]
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
