import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Emergency extends StatefulWidget{

  final String baby;
  final String userEntry;
  Emergency({Key? key, required this.baby, required this.userEntry}) : super(key: key);

  @override
  State<Emergency> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

      ),

        body: StreamBuilder(
            stream:FirebaseFirestore.instance.doc(widget.baby).snapshots(),
            builder: (context, snapshot){
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
        buildProfile(),
        buildName(snapshot['Name'].toString()),
        buildBio(snapshot),
        buildEmergencyInfo(snapshot),
      ]
    );
  }
  Widget buildEmergencyInfo(snapshot){
    return Text("No bio yet");
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
  Widget buildProfile(){
    return Center(
      child: Stack(
        children: [
          buildProfilePic(),
          Positioned(
            child: Icon(
              Icons.edit,
              size: 20,
            )
          )
        ]
      )
    );
  }
  Widget buildProfilePic() {
    final imagePath = "https://www.w3schools.com/images/w3schools_green.jpg";
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