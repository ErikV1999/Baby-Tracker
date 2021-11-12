import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/baby_menu.dart';
import  'package:baby_tracker/screens/EditBio.dart';
import 'package:baby_tracker/screens/edit_pic.dart';

class Emergency extends StatefulWidget{

  final String baby;
  final String userEntry;
  Emergency({Key? key, required this.baby, required this.userEntry}) : super(key: key);

  @override
  State<Emergency> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {

  String bio = "";

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

      ),

        body: StreamBuilder(
            stream:FirebaseFirestore.instance.doc(widget.baby).snapshots(),
            builder: (context,snapshot){
              if(!snapshot.hasData)
                return Text("Something went wrong");
              return screen(snapshot.data);
            }
        )

    );
  }
  Widget screen(snapshot){
    return ListView(
      children: [
        buildProfile(snapshot),
        buildName(snapshot['Name'].toString()),
        Container(
          child: buildBio(snapshot),
          padding: EdgeInsets.fromLTRB(0, 20, 12, 10),
        ),
        Container(
          child:buildEmergencyInfo(snapshot),
          padding: EdgeInsets.fromLTRB(0,20,12,20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
            child: TextButton(
                child: Text("Edit"),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  EditBio(baby: widget.baby, userEntry: widget.userEntry, bio:bio)),
                  );
                }
            )
        ),
      ]
    );
  }
  Widget buildEmergencyInfo(snapshot){
    //if(!snapshot.containsKey("emergency"))
    //if(snapshot.contains("emergency"))
      //return Text("No bio yet");
    //if(!snapshotDoc.containsKey('emergency'))
      //return Text("Add emergency info");
    //return Text(snapshotDoc.data['emergency']);
    try{
      //setState(() {
        bio = snapshot['emergency'];
      //});
      //return Text(snapshot['emergency']);
    }
    on StateError catch(e){
      bio = "";
      return Text("No emergency information yet!");
      //return Text("No bio yet");
    }
    return Text(bio);

  }
  Widget buildBio(snapshot){
    return Column(
      
      children:[
        Text("Date of Birth: " + snapshot['dob'].toString()),
        Text("Height: " + snapshot['feet'].toString() + "'" + snapshot['inches'].toString() + "\""),


      ]

    );
  }
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
  Widget buildProfile(snapshot){

    String imagePath;

    try{
      imagePath = snapshot['image'];
    }
    on StateError catch(e){
      imagePath = "https://www.w3schools.com/images/w3schools_green.jpg";
    }

    return Center(
      child: Stack(
        children: [
          buildProfilePic(imagePath),
          Positioned(
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: IconButton(
                icon: Icon(Icons.edit),
                color: Colors.black,
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  EditPic(baby: widget.baby, userEntry: widget.userEntry)),
                  );
                }

              )
            ),
            //child: Container(
            //  color: Colors.green,
            //  child:  IconButton(
            //    iconSize: 40,
            //    onPressed: (){
//
             //   }
             // )
            //),
          )
        ]
      )
    );
  }
  Widget buildProfilePic(String imagePath) {
    //final imagePath = "https://www.w3schools.com/images/w3schools_green.jpg";
    final image = NetworkImage(imagePath);
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