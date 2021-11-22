import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Milestones.dart';

class EditNote extends StatefulWidget {
  final DocumentSnapshot document;
  final String baby;

  const EditNote({Key? key, required this.document, required this.baby}) : super(key: key);

  @override
  _EditNoteState createState() => _EditNoteState();
}


class _EditNoteState extends State<EditNote> {
  late String title;
  TextEditingController description = TextEditingController();
  late String filePath;   //holds path for image selected
  //stores result of file picker. Used to display selected image
  late Future<FilePickerResult?> result = Future.value(null);
  late File? _file;   //stores converted filePath
  late UploadTask? uploadTask;  //created when uploading file to storage


  //selects an image
  Future<FilePickerResult?> selectImage() async {
    try {
      FilePickerResult? _result = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);

      filePath = _result!.files.single.path.toString();   //stores path of image
      _file = File(filePath);   //converts filePath into type File

      return _result;   //returns result of file picker

    } on PlatformException catch (e) {
      print("Select Image Unsupported operation" + e.toString());
    } catch (error) {
      print("select image error");
    }
  }

  @override
  void initState() {
    filePath = widget.document['image'].toString();   //initializes filePath from image stored in current note
    title = widget.document['title'];   //initializes title
    description = TextEditingController(text: widget.document['description']);  //initializes content of note
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Note'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          buildDeleteButton(),    //builds delete button
          buildSaveButton(),      //builds save button
        ],
      ),

      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(3),
            child: Column(
              children: [
                TitleTile(),    //builds title tile

                //builds Text box for the contents of note
                Form(
                  child: Container(
                    padding: const EdgeInsets.only(left: 3, right: 3, top: 8, bottom: 10),
                    child: TextFormField(
                      decoration:  InputDecoration(
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
                      controller: description,
                      maxLines: 20,
                      onChanged: (val) {},
                    ),
                  ),
                ),

                Row(
                  children: [
                    //Builds button to select image from gallery
                    IconButton(
                      onPressed: () async {
                        /*
                            onPressed call select image which returns a Future FilePickerResult
                            then set state
                         */
                        result = selectImage().whenComplete(() {
                          setState(() {});
                        });
                      },
                      icon: Icon(Icons.photo_library),
                      iconSize: 45,
                    ),
                  ],
                ),

                /*Future builder displays image when user selects file
                  Or if user has an image stored for current note
                */
                FutureBuilder<FilePickerResult?>(
                    future: result,
                    builder: (context, snap) {
                      //if FilePickerResult has data...
                      if(snap.hasData) {
                        //check if file path is not empty
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
                          //if no image has been selected then display 'No image'
                        } else {
                          return Text('No image selected');
                        }
                      }
                      //if FilePickerResult has no data
                      else {
                        //check if the file path is empty
                        if(filePath.isEmpty) {
                          //display no images selected
                          return Text('No image selected');

                          //if not empty then current note already has an image saved
                        }else {
                          //display image
                          return Stack(
                            children: [
                              Image.network(filePath),

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
                        }
                      }
                    }
                ),

                //displayImage(),
              ],
            ),
          )
      ),
    );
  }

  //uploads image to firebase storage
  Future<String> upload() async{
    if(filePath.isEmpty)        //if no file chosen, dont do anything
      return '';
    //if file is chosen
    final fileName = filePath.split('/').last;              //gets file name form file path
    final babyID = widget.baby.split('/').last;             //gets baby doc ID
    final destination = "NotePics/${babyID}/${fileName}";    //sets destination to NotePics/babyID/fileName
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

  //updates note
  void updateNote() async {
    String url = await upload();

    widget.document.reference.update({
      'title': title,
      'description': description.text,
      'timestamp': DateTime.now(),
      'image': url,
    }).whenComplete(() => Navigator.pop(context));
  }

  //builds save button
  Widget buildSaveButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 12, 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent),
        child: Text(
          'Save',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => {updateNote()},  //calls update note on press
      ),
    );
  }

  //builds delete button
  Widget buildDeleteButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 12, 10),
      child: ElevatedButton(
        child: Icon(Icons.delete, color: Colors.white,),
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
        ),
        onPressed: () => {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Confirm Deletion'),
                content: Text('Confirm deletion of note'),
                actions: [
                  TextButton(
                    child: Text('Confirm'),
                    onPressed: () {
                      //deletes note document
                      widget.document.reference.delete().whenComplete(() => Navigator.pop(context))
                          .then((value) => Navigator.pop(context));
                    },
                  ),

                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          ),
        },
      ),
    );
  }

  //tile displays title and milestones when tapped
  Widget TitleTile() {
    return InkWell(
      onTap: () async {
        title = await Navigator.push(
            context,
            //directs you to screen where you can write you own title
            //or choose for pre-defined milestones
            MaterialPageRoute(builder: (context) => Milestones())
        );
        setState(() {});
      },
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 34),
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

}
