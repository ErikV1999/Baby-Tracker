import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/services/auth.dart';
import 'package:flutter/material.dart';

class FirestoreDatabase {

  CollectionReference users = FirebaseFirestore.instance.collection('Users');   //ref to user collection
  CollectionReference displayToUid = FirebaseFirestore.instance.collection('DisplayNames'); //ref to collection that maps displayID to uid


  //adds user to database with uid as its document id
  //creates displayID by combining name with random number
  Future<void> addUser(String uid, String name) async {
    Random random = new Random();
    var num = random.nextInt(9999).toString();  //generates random number 0-9999

    String displayID = name + '#${num}';    //appends rand num to user's name

    //pushes name and displayID to Users collection
    await users.doc(uid).set({
      'name': name,
      'caretaking': [],
      'displayID': displayID,
    }).then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

    //pushes map of displayID to uid onto DisplayNames collection
    await displayToUid.doc(displayID).set({
      'uid': uid,
    }).then((val) => print("DisplayID Added to map"))
        .catchError((error) => print("Failed to add displayID to map: $error"));
  }

  //takes user's displayID and returns uid
  Future<String> getUserFromDisplayID(String displayID) async {
    print('DisplayID getting converted to uid: $displayID');

    //get userID from DisplayName collection
    //if displayID exists then return uid
    //if not, return "User Not Found"
    String userID = await displayToUid.doc(displayID).get()
      .then((DocumentSnapshot snapshot) {
        if(snapshot.exists) {
          print('Doc snapshot data: ${snapshot.data()}');
          print('User ID: ${snapshot['uid']}');
          return snapshot['uid'];   //return uid
        }else{
          print('Document does not exist');
          return 'User Not Found';    //return "User Not Found"
        }
      }).catchError((error) => print("Error: Failed to get User from DisplayID"));

      return userID;
  }

  Future<void> addBaby(String name, String gender, int feet, int inches, DateTime date, String userEntry) async {
    final uid = await AuthService().getUID();
    CollectionReference babies = users.doc(uid).collection('Babies');

    int dob = date.millisecondsSinceEpoch;

    await babies.add({
      'Name': name,
      'gender': gender,
      'feet': feet,
      'inches': inches,
      'dob': dob,
      'Diaper': 'N/A',
      'Feeding': 0,
      'Sleeping': 0,
      'caretaker' : [userEntry],
      'parent' : userEntry,
    })
        .then((value) => print('Baby Added'))
        .catchError((error) => print("Failed to add baby"));
  }

  Future<void> addSleepTime(String? date, String? startTime, String? stopTime, int totalHour, int totalMin, int indexDate, String notes, String path, String? subDate) async {
    final uid = await AuthService().getUID();

    CollectionReference sleepingPath = FirebaseFirestore.instance.doc(path).collection('sleeping');

    await sleepingPath.add({
      'SleepingDate' : date,
      'StartSleeping': startTime,
      'StopSleeping': stopTime,
      'TotalHoursSlept': totalHour,
      'TotalMinutesSlept': totalMin,
      'indexDate': indexDate,
      'Notes': notes,
      'SubmitDate': subDate,
    })
        .then((value) => print('Sleep Added'))
        .catchError((error) => print("Failed to add sleeping data"));
  }

  Future<void> updateLastSleep(String? sleepTime, String totalSleep, String path) async {
    final uid = await AuthService().getUID();
    users
      .doc(uid)
      .collection('Babies')
      .doc(path)
      .update({'Sleeping': sleepTime})
      .then((value) => print('Last Sleep Updated'))
      .catchError((error) => print("Failed to add sleeping data"));
    users
        .doc(uid)
        .collection('Babies')
        .doc(path)
        .update({'TotalSleeping': totalSleep})
        .then((value) => print('Last Sleep Updated'))
        .catchError((error) => print("Failed to add sleeping data"));
  }



  Future<void> addFeeding(String feedingType, DateTime _startDate, int indexDate, int totalTimeSec, String foodType, String amount, String notes, String path) async {
    final uid = await AuthService().getUID();

    CollectionReference feedingPath = FirebaseFirestore.instance.doc(path).collection('feeding');

    await feedingPath.add({
      'feeding type': feedingType,
      'date': _startDate,
      'index date': indexDate,
      'total Time in seconds': totalTimeSec,
      'food type': foodType,
      'amount': amount,
      'notes': notes,
    })
        .then((value) => print('Feeding Added'))
        .catchError((error) => print("Failed to add Feeding data"));
  }
  Future<void> updateLastFeed(String totalFeed, String path) async {
    FirebaseFirestore.instance
        .doc(path)
        .update({'Feeding': totalFeed})
        .then((value) => print('Last Feeding Updated'))
        .catchError((error) => print("Failed to add sleeping data"));
  }

  Future<void> addDiaper(DateTime date, String notes, String status, String path) async {
    CollectionReference diaperChangePath = FirebaseFirestore.instance.doc(path).collection('diaper change');

    await diaperChangePath.add({
      'date' : date,
      'status' : status,
      'Notes': notes,
    })
        .then((value) => print('diaper change Added'))
        .catchError((error) => print("Failed to add diaper change data"));

  }
  Future<void> updatediaperchange(DateTime date, String notes, String status, String path) async {
    FirebaseFirestore.instance
        .doc(path)
        .update({'date': date, 'status' : status, 'Notes' : notes,})
        .then((value) => print('Last Diaper Updated'))
        .catchError((error) => print("Failed to add Diaper data"));
  }

}