import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/screens/services/auth.dart';
import 'package:flutter/material.dart';

class FirestoreDatabase {

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  //adds user to database and uses user's Firebase Auth uid as its document id
  Future<void> addUser(String uid, String name) async {

    return users.doc(uid).set({
      'name': name,
      'caretaking': [],
    }).then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addBaby(String name, String gender, int feet, int inches, DateTime date) async {
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
    })
        .then((value) => print('Baby Added'))
        .catchError((error) => print("Failed to add baby"));
  }

  Future<void> addSleepTime(DateTime date, String startTime, String stopTime, String notes, String path) async {
    final uid = await AuthService().getUID();

    CollectionReference sleepingPath = FirebaseFirestore.instance.doc(path).collection('sleeping');

    await sleepingPath.add({
      'SleepingDate' : date,
      'StartSleeping': startTime,
      'StopSleeping': stopTime,
      'Notes': notes,
    })
        .then((value) => print('Sleep Added'))
        .catchError((error) => print("Failed to add sleeping data"));
  }

  Future<void> updateLastSleep(TimeOfDay sleepTime, String path) async {
    final uid = await AuthService().getUID();
    users
      .doc(uid)
      .collection('Babies')
      .doc(path)
      .update({'Sleeping': sleepTime})
      .then((value) => print('Last Sleep Updated'))
      .catchError((error) => print("Failed to add sleeping data"));
  }



  Future<void> addFeeding(String date, String time, String notes, String path) async {
    CollectionReference feeding = FirebaseFirestore.instance.doc(path).collection('feeding');

    await feeding.add({
      'date': date,
      'time': time,
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
    CollectionReference adddiaper = FirebaseFirestore.instance.doc(path).collection('diaper');

    await adddiaper.add({
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