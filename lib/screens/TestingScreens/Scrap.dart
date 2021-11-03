import 'package:baby_tracker/screens/services/FirestoreDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Scrap extends StatefulWidget {
  const Scrap({Key? key}) : super(key: key);

  @override
  _ScrapState createState() => _ScrapState();
}

class _ScrapState extends State<Scrap> {
  String displayID = 'Erik Velazquez#3831';
  String _uid = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
              child: Text('Press'),
              onPressed: () async {
                String str = await FirestoreDatabase().getUserFromDisplayID(displayID);
                setState(() {
                  _uid = str;
                });
              },
            ),

            Text(_uid),


          ],
        ),
      ),
    );
  }


  Future<String> getUserFromDisplayID(String displayID) async {
    print('FIRST: $displayID');

    await FirebaseFirestore.instance.collection('DisplayName').doc(displayID).get()
        .then((DocumentSnapshot snapshot) {
      if(snapshot.exists) {
        print('Doc snapshot data: ${snapshot.data()}');
        print('User ID: ${snapshot['uid']}');
        return snapshot['uid'];
      }else{
        print('Error: Document does not exist');
      }
    }).catchError((error) => print("Failed to get User from DisplayID"));
    return 'Nothing';
  }

}
