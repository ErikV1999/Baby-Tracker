import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Baby{
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

class MainMenu extends StatefulWidget{

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  dynamic userName = "Sarah";               //will eventually be fetched
  dynamic userEntry = "EGQ9WR5wqbedNAlSdhuu";   //will need to be sent in a form from prev page


  void babyClick(){
    //print(FirebaseFirestore.instance.collection('Babies').snapshots() );
    //print(FirebaseFirestore.instance.collection('Babies'));
    //print(FirebaseFirestore.instance.collection('Users').doc("EGQ9WR5wqbedNAlSdhuu ").collection("Babies"));
  }

  void addBabyClick(){

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
            babyClick();
          },
        )
      );
  }
  @override
  Widget build(BuildContext context){

    /*List babies = ["john", "jerry", "james"];   //will eventually be fetched
    //List feedings = [4, 2, 4,];                 //eventually be fetched
    List<Baby> babies = [
      Baby("john",4,2,3),
      Baby("jerry",4,2,3),
      Baby("jessie",4,2,3),
      Baby("james",4,2,3),
    ];
    //replace this with something scrollable
    List<ElevatedButton> buttons = [];        //stores the button widgets for each baby
    for(int i = 0; i < babies.length;i++){    //loop though for each baby
      buttons.add(                            //add a button that contains the baby's info
          ElevatedButton(
            child: Column(
                children: [
                  Text(babies[i].name),          //baby's name as the title
                  Row(                      //use a row because itll eventually contain feeding and diaper and
                      children: [
                        Text("Last Feeding " + babies[i].feeding.toString()),
                      ]
                  ),
                ]
            ),
            onPressed: (){
              babyClick(babies[i]);
            },
          )
      );
    }*/
    return Scaffold(
      appBar: AppBar(     //app bar is the bar at the top of the screen with the user's name
        title: Text(userName),
        centerTitle: true,
        backgroundColor: Colors.cyanAccent,
      ),
      floatingActionButton: FloatingActionButton(   //might replace add baby with this
        onPressed: (){},
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
      /*body: Column(
        children: [
          //Column(
            //children: buttons //make this scrollable
            //children:[
            //]
          //),
          ListView.builder(
            itemCount: babies.length,
            itemBuilder: (context, index){
              return _buildListItem(context, babies[index]);
            },
          ),
          Row(
            children:[
              ElevatedButton(
                child: Text("Add Baby"),
                onPressed: (){
                  addBabyClick();
                }
              ),
              ElevatedButton(
                child: Text("Accept Invite"),
                onPressed: (){
                  acceptInviteClick();
                }
              )
            ]
          )
        ]
      )*/
    );
  }
}