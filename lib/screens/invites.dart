import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Invites extends StatefulWidget{

  final String user;
  const Invites({Key? key, required this.user});

  @override
  State<Invites> createState() => _InvitesState();
}
/*

This screen contains a list of invites that the user has recieved. it can be accessed through the main menue
and through the caretaker screen in baby menu.

Takes the userID as input to get user data
 */
class _InvitesState extends State<Invites> {

  /*

  validate the baby exists before you attempt to add a caretaker to the doc.
  Takes the babyPath as input, returns if the doc is real
   */
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
            title: Text(document['babyName']),    //contains the babies name
            subtitle: Row(    //row contains the accept and decline options
              children: [
                ElevatedButton(
                  child: Text("Accept"),
                  onPressed: ()async{
                    bool valid = await validateBaby(document['babyPath']);    //validates the babies real
                    if(valid) {     //add user to the babies caregiver list
                      DocumentReference baby = FirebaseFirestore.instance
                          .doc(document['babyPath']);
                      await baby.update({
                        "caretaker": FieldValue.arrayUnion([widget.user])   //unions the userid
                      });
                    }

                    FirebaseFirestore.instance
                        .doc(document.reference.path)
                        .delete();                      //always delete the invite


                  }


                ),
                ElevatedButton(
                    child: Text("Decline"),
                    onPressed: (){
                      FirebaseFirestore.instance
                          .doc(document.reference.path)
                          .delete();                //deletes the invite if declined and does nothing else
                    }
                )
              ]
            ),
            onTap: ()async{
              //tapping the invite itself does nothing, only interact through the accpt/decline
            },
          )
      );
  }

  Widget build(BuildContext context){
    return StreamBuilder<dynamic>(        //builds with the users data for the display name
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.user)
          .snapshots(),
      builder: (context, snapshot){
        return buildWithDisplayID(context,snapshot.data);   //inputs the user doc into the screen for the display name
      }
    );
  }
/*

Build inside the build that builds with the users doc already downloaded. This allows it to know the display ID
 */
  Widget buildWithDisplayID(BuildContext context, snapshotDoc){
    Color bannerColor = Color(0xFF006992);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your ID: ' + snapshotDoc['displayID']),      //shows the display id at the top so they can show their friends
        backgroundColor: bannerColor,
      ),
      body: Container(
        child: StreamBuilder<dynamic>(
          stream: FirebaseFirestore.instance
              .collection('Invites')
              .where('receiver', isEqualTo: snapshotDoc['displayID'])   //searches the invites for user's invites
              .snapshots(),
          builder: (context, snapshot) {
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