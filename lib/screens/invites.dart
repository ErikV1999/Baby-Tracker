import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Invites extends StatefulWidget{

  final String user;
  const Invites({Key? key, required this.user});

  @override
  State<Invites> createState() => _InvitesState();
}

class _InvitesState extends State<Invites> {
  static Future<bool> validateBaby(String babyPath) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.doc(babyPath).get()
          .then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return exists;
    }
  }
  Widget _buildInviteItem(BuildContext context, DocumentSnapshot document){
    return
      Card(                                 //card encapsulates 1 Listtile
          child: ListTile(                    //each list tile is a baby
            //title: Text(document['Name']),    //pulls the babys name
            title: Text(document['babyName']),
            //subtitle: Text("Accept"),
            subtitle: Row(
              children: [
                ElevatedButton(
                  child: Text("Accept"),
                  onPressed: ()async{
                    bool valid = await validateBaby(document['babyPath']);
                    if(valid) {
                      DocumentReference baby = FirebaseFirestore.instance
                          .doc(document['babyPath']);
                      await baby.update({
                        "caretaker": FieldValue.arrayUnion([widget.user])
                      });
                    }

                    FirebaseFirestore.instance.doc(document.reference.path).delete();

                    //babyClick(document.reference.path);
                  }


                ),
                ElevatedButton(
                    child: Text("Decline"),
                    onPressed: (){
                      FirebaseFirestore.instance.doc(document.reference.path).delete();
                    }
                )
              ]
            ),
            onTap: ()async{

            },
          )
      );
  }

  Widget build(BuildContext context){
    return StreamBuilder<dynamic>(
      stream: FirebaseFirestore.instance.collection('Users').doc(widget.user).snapshots(),
      builder: (context, snapshot){
        return buildWithDisplayID(context,snapshot.data);
      }
    );
  }

  Widget buildWithDisplayID(BuildContext context, snapshotDoc){
    return Scaffold(
      appBar: AppBar(
        title: Text('Your ID: ' + snapshotDoc['displayID']),
      ),
      body: Container(
        child: StreamBuilder<dynamic>(
          stream: FirebaseFirestore.instance
              .collection('Invites')
              .where('receiver', isEqualTo: snapshotDoc['displayID'])
              .snapshots(),
          builder: (context, snapshot) {
            print(widget.user + " WHYY");
            if(!snapshot.hasData)                     //if the snapshot has any data in it
              return const Text('Loading...no data');
            if(snapshot.data.docs == null)
              return const Text('Loading...no docs');
            return ListView.builder(                  //builds each tile for each baby
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index){           //builds individual widgets
                  print(widget.user);
                  return _buildInviteItem(context, snapshot.data.docs[index]);
                }
            );
          }
        )
      )
    );
  }
}