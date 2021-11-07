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
        title: Text('Edit Note'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 12, 10),
            child: ElevatedButton(
              child: Icon(Icons.delete, color: Colors.white,),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              onPressed: () => {
                showDialog(
                context: context,
                builder: (_) => AlertDialog(
                    title: Text('Confirm Deletion'),
                    content: Text('Confirm deletion of note'),
                    actions: [
                      TextButton(
                        child: Text('Confirm'),
                        onPressed: () {
                          widget.document.reference.delete().whenComplete(() => Navigator.pop(context))
                              .then((value) => Navigator.pop(context));
                        },
                      ),

                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ),
              },
            ),
          ),


          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 12, 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent),
              child: Text(
                  'Save',
                style: TextStyle(color: Colors.white),
              ),
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
