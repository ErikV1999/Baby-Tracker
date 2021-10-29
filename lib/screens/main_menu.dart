import 'package:baby_tracker/screens/addbaby.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/services/auth.dart';

import 'package:baby_tracker/screens/baby_menu.dart';



class MainMenu extends StatefulWidget{

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  dynamic userName = "Sarah";               //will eventually be fetched
  dynamic userEntry = "EGQ9WR5wqbedNAlSdhuu";   //will need to be sent in a form from prev page
  //String userEntry = FirebaseAuth.instance.currentUser;
  final AuthService _auth = AuthService();

  void babyClick(String path){
    print(path);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  BabyMenu(baby: path)),
    );
  }

  void addBabyClick(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddBaby()),
    );
  }

  void acceptInviteClick(){

  }

  /*Builds a card to be displayed for a baby
    BuildContext context: is some boilerplate thing for the environment
      its from
    DocumentSnapshot document: is the data element extracted from the
      database

  */
  Widget _buildBabyItem(BuildContext context, DocumentSnapshot document){

    return
      Card(                                 //card encapsulates 1 Listtile
        child: ListTile(                    //each list tile is a baby
          title: Text(document['Name']),    //pulls the babys name
          subtitle: Text("Last Feeding: " + document['Feeding'].toString() +
            " Last Sleep: " + document['Sleeping'].toString() +
            " Last Diaper: " + document['Diaper'].toString()),
          onTap: (){
            babyClick(document.reference.path);
          },
        )
      );
  }

  /*

  encapsulates the "screen" widget where all the visuals are actually built
   */
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(     //builds the screen based on data it might not have yet
      future: _auth.getUID(),             //gets the users UID to get their document
      initialData: "Loading Text...",     //while it waits for the data to come in
      builder: (BuildContext context, AsyncSnapshot text){    //when the data arrives
        return screen(context, text);
      }
    );
  }
  /*
  where all the visuals are actually made. This function takes in the
  text: text is the data pulled in the "build" function that contains the users UID
  context: boilerplate context
   */
  Widget screen(BuildContext context, AsyncSnapshot text){
    //_auth.getUID();
    //userEntry = _auth.getUID();
    userEntry = text.data;
    //userName = FirebaseFirestore.instance.collection('Users').doc(userEntry).snapshots().data['Name'];
    return Scaffold(
      appBar: AppBar(     //app bar is the bar at the top of the screen with the user's name
        title: StreamBuilder(   //streambuilder here creates the title based on the users name in the database
          stream: FirebaseFirestore.instance.collection('Users').doc(userEntry).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Text("Jane Doe");
            }
            userName = snapshot.data;
            return Text(userName["name"]);

          }
        ),
        centerTitle: true,
        backgroundColor: Colors.cyanAccent,
        actions: <Widget>[      //sign out button at the appbar
          TextButton.icon(
            icon: Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();

            },
            label: Text('logout'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(   //button for the "add baby" at the bottom
        onPressed: () => addBabyClick(),
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[800],
      ),
      body: StreamBuilder<dynamic>(          //the body is a list of tiles showing each baby


          stream: FirebaseFirestore.instance
              .collection('Users')  //takes from the user table
              .doc(userEntry)       //finds the users document
              .collection("Babies")   //goes into users subcollectino for their babies
              .snapshots(),           //takes a snapshot

          builder: (context, snapshot){      //builds the list of widgets to display based on users babies
            if(!snapshot.hasData)                     //if the snapshot has any data in it
              return const Text('Loading...');
            if(snapshot.data.docs == null)            //if the collectino is empty
              return const Text('Loading...');
            return ListView.builder(                  //builds each tile for each baby
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){           //builds individual widgets
                return _buildBabyItem(context, snapshot.data.docs[index]);
              }
            );
          }
        )

    );
  }
}