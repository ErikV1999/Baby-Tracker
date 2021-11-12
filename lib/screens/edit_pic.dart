
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditPic extends StatefulWidget{

  final String baby;
  final String userEntry;
  EditPic({Key? key, required this.baby, required this.userEntry}) : super(key: key);

  @override
  State<EditPic> createState() => _EditPicState();
}

class _EditPicState extends State<EditPic> {
  
  File? file;
  UploadTask? uploadTask;

  Widget build(BuildContext context){

    String fileName;
    if(file==null)
      fileName = 'No Image Selected';
    else
      fileName = basename(file!.path);

    return Scaffold(
      appBar: AppBar(

      ),
      body: ListView(
        children: [
          Container(
            child: ElevatedButton(
              child: Text("Pick a Profile Pic"),
              onPressed: (){
                selectFile();
              }
            )
          ),
          Container(
            child: Text(fileName),
          ),
          Container(
              child: ElevatedButton(
                  child: Text("Upload Profile Pic"),
                  onPressed: (){
                    upload();
                  }
              )
          ),
        ]
      ),
    );
  }
  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image
    );
    if(result == null)
      return;
    final path = result.files.single.path!;
    setState(() => file = File(path));

  }
  Future upload() async{
    if(file == null)
      return;

    final fileName = basename(file!.path);
    final destination = "BabyPics/" + widget.baby;
    uploadTask = handleStorage(destination, file);
    if(uploadTask == null)
      return;
    final snapshot = await uploadTask!.whenComplete((){

    });
    final url = await snapshot.ref.getDownloadURL();
    updateFirebase(url);
  }
  void updateFirebase(url) async{
    FirebaseFirestore.instance.doc(widget.baby).update({
      'image' : url,
    }).whenComplete(()=>Navigator.pop(this.context));
  }
  UploadTask? handleStorage(destination, file){

    try{
      return FirebaseStorage
          .instance
          .ref(destination)
          .putFile(file!);
    } on FirebaseException catch(e){
      return null;
    }
  }
}