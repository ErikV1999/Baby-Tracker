import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class diaperentries extends StatefulWidget {
  final String baby; //contains path for baby in database
  const diaperentries({Key? key, required this.baby}) : super(key: key);

  @override
  _diaperentries createState() => _diaperentries();
}

class _diaperentries extends State<diaperentries> {

  @override

  Widget build(BuildContext context) {
    //get data from database
    Query diaperRef = FirebaseFirestore.instance.doc(widget.baby).collection('diaper change').orderBy("date", descending: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diaper Change Entries',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: diaperRef.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //if true then print out entries in cards
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map data = snapshot.data!.docs[index].data() as Map;
                Timestamp t = data['date'];
                DateTime thisTime = t.toDate();
                String formatTime = "${thisTime.year.toString()}-${thisTime.month.toString().padLeft(2,'0')}-${thisTime.day.toString().padLeft(2,'0')} "
                    "${thisTime.hour.toString().padLeft(2,'0')}:${thisTime.minute.toString().padLeft(2,'0')}";
                return GestureDetector(
                  // if a card is clicked then prompt user if they want to delete entry
                  onTap: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          AlertDialog(
                            title: const Text('Delete Diaper Change Entry?'),
                            content: Text("Date: " "${formatTime}, \n" +
                                "Status of diaper:" + "${data['status']},\n" +
                                "Notes: " + "${data['Notes']},",),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                //if clicked ok then delete data from database
                                onPressed: () {
                                  snapshot.data!.docs[index].reference.delete();
                                  setState(() {

                                  });
                                  Navigator.pop(context, 'OK');
                                },
                                child: const Text('Delete', style: TextStyle(color: Colors.red),),
                              ),
                            ],
                          ),
                    );
                  },
                  child: Card(
                    //Following prints how diaper change data in a card
                    //Informtaion includes Date, Status of diaper, and Notes
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date: " "${formatTime}, \n" +
                              "Status of diaper:" + "${data['status']},\n" +
                              "Notes: " + "${data['Notes']},",
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
          } else {
            //if data could not be gathered just print out loading
            return Center(child: Text('Loading...'));
          }
        },
      ),
    );
  }
}

