import 'package:flutter/material.dart';
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



  void babyClick(Baby baby){
    print(baby.name);
  }

  void addBabyClick(){

  }

  void acceptInviteClick(){

  }

  @override
  Widget build(BuildContext context){
    dynamic userName = "Sarah";               //will eventually be fetched
    //List babies = ["john", "jerry", "james"];   //will eventually be fetched
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
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
        centerTitle: true,
        backgroundColor: Colors.cyanAccent,
      ),
      floatingActionButton: FloatingActionButton(   //might replace add baby with this
        onPressed: (){},
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[800],
      ),
      body: Column(
        children: [
          Column(
            children: buttons //make this scrollable
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
      )
    );
  }
}