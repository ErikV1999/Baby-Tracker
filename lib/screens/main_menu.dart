import 'package:baby_tracker/screens/addbaby.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/services/auth.dart';
import 'dart:async';

import 'package:baby_tracker/screens/baby_menu.dart';

/*class Baby{
  String name = "";
  int feeding = -1;
  int sleeping = -1;
  int diaper = -1;

  Baby(String n, int f, int s, int d){
    name = n;
    feeding = f;
    sleeping = s;
    diaper = d;
  }

}
*/
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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _auth.getUID(),
      initialData: "Loading Text...",
      builder: (BuildContext context, AsyncSnapshot text){
        return screen(context, text);
      }
    );
  }

  Widget screen(BuildContext context, AsyncSnapshot text){
    //_auth.getUID();
    //userEntry = _auth.getUID();
    userEntry = text.data;
    //userName = FirebaseFirestore.instance.collection('Users').doc(userEntry).snapshots().data['Name'];
    return Scaffold(
      appBar: AppBar(     //app bar is the bar at the top of the screen with the user's name
        //title: Text(userName),
        title: StreamBuilder(
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
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();

            },
            label: Text('logout'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(   //might replace add baby with this
        onPressed: () => addBabyClick(),
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[800],
      ),
      body: StreamBuilder<dynamic>(          //the body is a list of tiles showing each baby

          //stream: FirebaseFirestore.instance.collection('Babies').snapshots(),
          stream: FirebaseFirestore.instance.collection('Users').doc(userEntry).collection("Babies").snapshots(),
              //.where('Document ID', isEqualTo: 'EGQ9WR5wqbedNAlSdhuu ').snapshots(),

          builder: (context, snapshot){      //builds the list of widgets to display
            if(!snapshot.hasData)                     //if the snapshot has any data in it
              return const Text('Loading...');
            if(snapshot.data.docs == null)            //if the doc is null
              return const Text('Loading...');
            return ListView.builder(                  //is the list of tiles contained in the builder
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