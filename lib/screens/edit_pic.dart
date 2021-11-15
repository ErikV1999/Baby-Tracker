
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditPic extends StatefulWidget{

  final String baby;        //baby document path
  final String userEntry;   //users document ID
  EditPic({Key? key, required this.baby, required this.userEntry}) : super(key: key);

  @override
  State<EditPic> createState() => _EditPicState();
}

class _EditPicState extends State<EditPic> {

  File? file;               //file chosen by the user
  UploadTask? uploadTask;   //the upload task created when uploading the file to storeage
  /*

  required build function. Contains all the widgets for the eidting picture screen

  Context: build context boilerplate
   */
  Widget build(BuildContext context){

    String fileName;      //gets the string filename from the file
    if(file==null)        //default if theres no file chosen
      fileName = 'No Image Selected';
    else                //if theres a file chosen
      fileName = basename(file!.path);

    return Scaffold(
      appBar: AppBar(

      ),
      body: ListView(       //contains all 3 elements of the apge
        children: [
          Container(            //choose file button
            child: ElevatedButton(
              child: Text("Pick a Profile Pic"),
              onPressed: (){
                selectFile();
              }
            )
          ),
          Container(           //display file name text
            child: Text(fileName),
          ),
          Container(          //send file as profile pic
              child: ElevatedButton(
                  child: Text("Set As Pic"),
                  onPressed: (){
                    upload();
                  }
              )
          ),
        ]
      ),
    );
  }
  /*
  SelectFile() is the async functino that runs when the select file button is pressed in the build function.
  Opens up a system menu to pick a file from local files.

  returns a future if no result is chosen, otherwise uses a setstate to save file
   */
  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,     //only allow 1 image pic
        type: FileType.image      //only allow pictures to be chosen
    );
    if(result == null)          //if no file is chosen
      return;                   //dont attempt to set file
    final path = result.files.single.path!;   //if file is chosen,
    setState(() => file = File(path));        //set file to file path

  }
  /*
  upload() is a async functino that runs when the user clicks the "upload" button. Takes the file
  specificed by the user and uploads it to the firebase storage

  takes no parameters

  returns only if the storage fails.
  saves the storage URL as url.
   */
  Future upload() async{
    if(file == null)        //if no file chosen, dont do anything
      return;
    //if file is chosen
    final fileName = basename(file!.path);    //set filename to a string of the file path
    final destination = "BabyPics/" + widget.baby;    //sets the file name as the babies path to make it unique and easily overwritten by itself
    uploadTask = handleStorage(destination, file);    //sends the file to storage and takes the upload task
    if(uploadTask == null)      //if the upload task is null, somethings gone wrong, end the function
      return;
    final snapshot = await uploadTask!.whenComplete((){     //take the returned snapshot after it uplads

    });
    final url = await snapshot.ref.getDownloadURL();    //take the url of the image from the snapshot
    updateFirebase(url);                                //put the url in the baby
  }
  /*
  updateFirebase() is an async function that runs after teh upload() function

  url: url passed from the call to firebase storage, allows the picture to be referenced

  returns nothing unless theres an error, then null
   */
  void updateFirebase(url) async{
    FirebaseFirestore.instance.doc(widget.baby).update({    //update the 'image' field with the image url in storage
      'image' : url,
    }).whenComplete(()=>Navigator.pop(this.context));
  }
  UploadTask? handleStorage(destination, file){

    try{      //try to put the image in storage
      return FirebaseStorage
          .instance
          .ref(destination)
          .putFile(file!);
    } on FirebaseException catch(e){    //if something goes wrong, return null
      return null;
    }
  }
}