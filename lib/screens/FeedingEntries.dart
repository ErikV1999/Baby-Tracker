import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/FeedingStats.dart';

class FeedingEntries extends StatefulWidget {

  final String baby;

  const FeedingEntries({Key? key, required this.baby}) : super(key: key);
  @override
  _FeedingEntriesState createState() => _FeedingEntriesState();
}

class _FeedingEntriesState extends State<FeedingEntries> {
  dynamic babyName = "Placeholder";

  @override
  Widget build(BuildContext context) {
    Query feedRef = FirebaseFirestore.instance.doc(widget.baby).collection('feeding').orderBy("date day", descending: true);//change to index day :p
    String babyPath = widget.baby;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //title: Text(babyPath),
        title: Text('Feeding Entries',
          style: TextStyle(color: Colors.black, fontSize: 20,),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: feedRef.get(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map data = snapshot.data!.docs[index].data() as Map;
                return GestureDetector(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data['notes']}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text("Date: " "${data['date month']}/${data['date day']}/${data['date year']} ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              )
                          ),
                        ],
                      ),
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