import 'dart:io';

import 'package:baby_tracker/screens/Notes/Milestones.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddNote extends StatefulWidget {
  final String baby;
  const AddNote({Key? key, required this.baby}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late String title = 'Title';
  late String description;
  String filePath = '';   //stores path to image
  late File? _file;       //converts filePath to type File
  late UploadTask? uploadTask;  //created when storing files to storage
  //stores result of file picker. Used to display selected image
  late Future<FilePickerResult?> result = Future.value(null);

  //selects an image
  Future<FilePickerResult?> selectImage() async {
    try {
      FilePickerResult? _result = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);

      filePath = _result!.files.single.path.toString(); //stores file path of image
      _file = File(filePath);   //converts filePath to type File

      return _result;   //returns FilePickerResult

    } on PlatformException catch (e) {
      print("Select Image Unsupported operation" + e.toString());
    } catch (error) {
      print("select image error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('New Note'),
       //backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          //builds Save button
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 12, 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent),
              child: Text(
                  'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                addNote();  //on pressing save call addNote
              },
            ),
          ),
        ],
      ),


      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              TitleTile(),  //builds title tile
              //builds text box for contents of notes
              Form(
                  child: Container(
                    padding: const EdgeInsets.only(left: 3, right: 3, top: 8, bottom: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Note Description',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).dividerColor,
                            style: BorderStyle.solid,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).dividerColor,
                            style: BorderStyle.solid,
                          ),
                        ),

                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 20,

                      onChanged: (val) {
                        description = val;
                      },
                    ),
                  ),
              ),

              Row(
                children: [
                  IconButton(
                    /*
                            onPressed call select image which returns a Future FilePickerResult
                            then set state
                         */
                    onPressed: () async {
                      result = selectImage().whenComplete(() {
                        setState(() {});
                      });
                    },
                    icon: Icon(Icons.photo_library),
                    iconSize: 45,
                  ),
                ],
              ),

              //Future Builder displays image when user selects file
              FutureBuilder<FilePickerResult?>(
                  future: result,
                  builder: (context, snap) {
                    //if FilePickerResult has data...
                    if(snap.hasData) {
                      //check if filePath is not empty
                      if(filePath.isNotEmpty ) {
                        //if so then display image
                        return Stack(
                          children: [
                            Image.file(File(filePath)),
                            //icon deletes image that was selected
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  filePath = '';
                                });
                              },
                              icon: Icon(Icons.cancel),
                              color: Colors.grey,
                            ),
                          ],
                          alignment: AlignmentDirectional.topEnd,
                        );
                      } else {
                        //if no image has been selected then display 'No image'
                        return Text('No image selected');
                      }
                    }
                    //if FileImagePicker has no data then display 'No image'
                    else {
                      return Text('No image selected');
                    }
                  }
              ),
              
            ],
          ),
        )
      ),
    );
  }

  Widget TitleTile() {
    return InkWell(
      onTap: () async {
        title = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Milestones())
        );
        setState(() {});
      },
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 34,),
        ),
        trailing: Icon(
          Icons.arrow_drop_down,
          size: 50,
        ),
        shape: ContinuousRectangleBorder(
            side: BorderSide(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  //uploads image to FirebaseStorage
  Future<String> upload() async{
    if(filePath.isEmpty)        //if no file chosen, dont do anything
      return '';
    //if file is chosen
    final fileName = filePath.split('/').last;    //gets file name from file path
    final babyID = widget.baby.split('/').last;   //gets baby doc ID
    final destination = "NotePics/${babyID}/${fileName}";   //sets destination to NotePics/babyID/fileName
    uploadTask = handleStorage(destination, _file);    //sends the file to storage and takes the upload task
    if(uploadTask == null)      //if the upload task is null, somethings gone wrong, end the function
      return '';
    final snapshot = await uploadTask!.whenComplete((){     //take the returned snapshot after it uplads

    });
    final url = await snapshot.ref.getDownloadURL();    //take the url of the image from the snapshot
    return url;                                //put the url in the baby
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

  //adds new notes doc to baby's note collection
  void addNote() async {
    String url = await upload();
    CollectionReference notesRef = FirebaseFirestore.instance.doc(widget.baby).collection('notes');
    var data = {
      'title': title,
      'description': description,
      'timestamp': DateTime.now(),
      'image': url,
    };

    notesRef.add(data);   //puts new doc into baby's note collection

    Navigator.pop(context);   //pop to previous screen
}

}
