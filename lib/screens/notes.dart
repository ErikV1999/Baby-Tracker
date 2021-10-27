import 'package:baby_tracker/screens/addnote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notes extends StatefulWidget {
  final String baby;

  const Notes({Key? key, required this.baby}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  @override
  Widget build(BuildContext context) {
    CollectionReference notesRef = FirebaseFirestore.instance.doc(widget.baby).collection('notes');

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.amber,
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNote(baby: widget.baby)),
          )
            .then((value) {
              print('Calling Set State');
              setState(() {});
          });
        },
      ),

      body: FutureBuilder<QuerySnapshot>(
          future: notesRef.get(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map data = snapshot.data!.docs[index].data() as Map;
                  DateTime date = data['timestamp'].toDate();
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${data['title']}",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          Container(
                            alignment: Alignment.bottomRight,
                            child: Text(
                                DateFormat.yMMMd().add_jm().format(date),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              );
            }else {
              return Center(child: Text('Loading...'));
            }
          },
      ),

    );
  }
}
