import 'package:flutter/material.dart';
import 'dart:async';

class MainMenu extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    dynamic userName = "Sarah";               //will eventually be fetched
    List babies = ["john", "jerry", "james"];   //will eventually be fetched
    List feedings = [4, 2, 4,];                 //eventually be fetched
    List<ElevatedButton> buttons = [];        //stores the button widgets for each baby
    for(int i = 0; i < babies.length;i++){    //loop though for each baby
      buttons.add(                            //add a button that contains the baby's info
          ElevatedButton(
            child: Column(
                children: [
                  Text(babies[i]),          //baby's name as the title
                  Row(                      //use a row because itll eventually contain feeding and diaper and 
                      children: [
                        Text("Last Feeding " + feedings[i].toString()),
                      ]
                  ),
                ]
            ),
            onPressed: (){},
          )
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
        centerTitle: true,
        backgroundColor: Colors.cyanAccent,
      ),
      body: Column(
        children: buttons

      )
    );
  }
}