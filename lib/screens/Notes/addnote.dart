import 'dart:io';

import 'package:baby_tracker/screens/Notes/Milestones.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
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
  List<File> filePaths = [];
  List<String> fileNames = [];
  late Future<FilePickerResult?> result = Future.value(null);

  Future<FilePickerResult?> selectImage() async {
    try {
      FilePickerResult? _result = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);
      return _result;
/*
      if (result != null) {
        filePaths.clear();
        result.files.forEach((selectedFile) {
          File file = File(selectedFile.path!);
          filePaths.add(file);
        });

        setState(() {
          fileNames.clear();
          result.files.forEach((i) {
            fileNames.add(i.name);
          });
        });
      }

 */
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
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 12, 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent),
              child: Text(
                  'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => add(),
            ),
          ),
        ],
      ),


      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              TitleTile(),

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
              
              FutureBuilder<FilePickerResult?>(
                  future: result,
                  builder: (context, snap) {
                    if(snap.hasData) {
                      //print(snap.data);
                      return Column(
                        children: [
                          Container(
                            child: Image.file(File(snap.data!.files.single.path.toString())),
                          ),
                        ],
                      );
                    }
                    else {
                      return Text('No images');
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

  void add() async {
    CollectionReference notesRef = FirebaseFirestore.instance.doc(widget.baby).collection('notes');
    var data = {
      'title': title,
      'description': description,
      'timestamp': DateTime.now(),
    };

    notesRef.add(data);

    Navigator.pop(context);
}

}
