import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/baby_menu.dart';
import  'package:baby_tracker/screens/EditBio.dart';
import 'package:baby_tracker/screens/edit_pic.dart';

class Emergency extends StatefulWidget{

  final String baby;      //stores the babies path
  final String userEntry; //stores the doc ID of teh user
  Emergency({Key? key, required this.baby, required this.userEntry}) : super(key: key);

  @override
  State<Emergency> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {

  String emergencyInfo = "";      //the internal variable for the emergency information text
/*
standard build function required. Contains a streambuilder and calls screen() where
the widgets are actually built

context: build context boilerplate
 */
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

      ),

        body: StreamBuilder(    //create  a screen based on the babies document information
            stream:FirebaseFirestore.instance.doc(widget.baby).snapshots(),
            builder: (context,snapshot){
              if(!snapshot.hasData)
                return Text("Something went wrong");
              return screen(snapshot.data);
            }
        )

    );
  }
  /*
  the screen thats displayed inside the build functino. builds with teh babies document
  information in snapshot

  snapshot: babies document with required information

  returns the screen widget
   */
  Widget screen(snapshot){    //screen created with the babies information retrieved
    return ListView(          //contains all the elements on the page in a list
      children: [
        buildProfile(snapshot),     //builds the profile pic
        buildName(snapshot['Name'].toString()),   //builds teh name text under
        Container(                  //builds the bio information like dob and height
          child: buildBio(snapshot),
          padding: EdgeInsets.fromLTRB(0, 20, 12, 10),
        ),
        Container(                  //builds the emergency info card
          child:buildEmergencyInfo(snapshot),
          padding: EdgeInsets.fromLTRB(0,20,12,20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        Align(                      //builds the edit button
          alignment: Alignment.topLeft,
            child: TextButton(
                child: Text("Edit"),
                onPressed: (){
                  Navigator.push(     //goes to the editing page when pressed
                    context,
                    MaterialPageRoute(builder: (context) =>  EditBio(baby: widget.baby, userEntry: widget.userEntry, bio:emergencyInfo)),
                  );
                }
            )
        ),
      ]
    );
  }
  /*
  builds the emergency info text box

  snapshot: the baby doc information to check if the baby already has info

  returns a widget of a text box
   */
  Widget buildEmergencyInfo(snapshot){

    try{    //try to see if the baby has emergency information

      emergencyInfo = snapshot['emergency'];

    }
    on StateError catch(e){       //if not, set it to a default to display
      emergencyInfo = "";
      return Text("No emergency information yet!");
      //return Text("No bio yet");
    }
    return Text(emergencyInfo);   //display babies info if it has it

  }
  /*
  builds the bio information like the dob and the hheight of the baby

  snapshot: the baby doc information

  reutrns a column of 2 texts
   */
  Widget buildBio(snapshot){
    var dateOfBirth = DateTime.fromMillisecondsSinceEpoch(snapshot['dob'] );    //converts teh dob from int
    return Column(

      children:[
        //Text("Date of Birth: " + snapshot['dob'].toString()),
        //Text("Date of Birth: " + dateOfBirth.toString()),
        Text("Date of Birth: " + dateOfBirth.year.toString() +"-"+ dateOfBirth.month.toString() +"-"+ dateOfBirth.day.toString()),
        Text("Height: " + snapshot['feet'].toString() + "'" + snapshot['inches'].toString() + "\""),


      ]

    );
  }
  /*
  buildName() is a function to create the text box of the babies name

  name: name taken from the document previosly

  returns a text with the babies name
   */
  Widget buildName(String name){
    return Center(
        child: Text(
            name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            )
        )
    );
  }
  /*
  buildProfile() returns the profile picture with container decorations

  snapshot: babies document info to be parsed

  returns the profile circle
   */
  Widget buildProfile(snapshot){

    String imagePath;     //image path is the url of the image to be used

    try{    //try if the baby has an image already
      imagePath = snapshot['image'];
    }       //use w3 schools image as a default
    on StateError catch(e){
      imagePath = "https://firebasestorage.googleapis.com/v0/b/babytracker-c3834.appspot.com/o/Default_pfp.jpg?alt=media&token=aea6a30a-5ddd-4b78-a2d5-e678e73fb5f7";
    }

    return Center(      //encapsulates the profile pic with other things
      child: Stack(     //stakc the edit icon ontop of the image
        children: [
          buildProfilePic(imagePath),   //add the iamge
          Positioned(
            child: CircleAvatar(        //build the edit icon circle
              backgroundColor: Colors.green,
              child: IconButton(
                icon: Icon(Icons.edit),
                color: Colors.black,
                onPressed: (){
                  Navigator.push(       //go to the edit image page
                    context,
                    MaterialPageRoute(builder: (context) =>  EditPic(baby: widget.baby, userEntry: widget.userEntry)),
                  );
                }

              )
            ),

          )
        ]
      )
    );
  }
  /*
  builds the actual picture oval

  imagePath: path to teh url of teh iamge being used. if its in the baby itll use that
  otherwise default to w3 schools pic

  returns a pic
   */
  Widget buildProfilePic(String imagePath) {
    //final imagePath = "https://www.w3schools.com/images/w3schools_green.jpg";
    final image = NetworkImage(imagePath);    //fetches the image
    return ClipOval(
      child: Material(
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128
        )
      )
    );
  }
}