// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/screens/NotesScreesn.dart';

import '../db/database_model.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);
  static String routename = "/addnote";

  @override
  State<AddNoteScreen> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNoteScreen> {
  final db = DatabaseModel.instance;
  var titleEdited = "";
  var contentEdited = "";
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController contentcontroller = TextEditingController();

  void addNote() async {
    NoteModel note = NoteModel(title: titleEdited, content: contentEdited);
    final id = await db.insertNote(note);
    Navigator.of(context, rootNavigator: true).pop();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              NotesScreen()), // this mymainpage is your page to refresh
      (Route<dynamic> route) => false,
    );
    titleEdited = "";
    contentEdited = "";
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Note'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are You Sure you want to save the note?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                addNote();
                Navigator.of(context).pop();
                Fluttertoast.showToast(
                    msg: "Note Saved Successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                // Navigator.of(context).pushNamed(NotesScreen.routename);
              },
            ),
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            TextField(
              controller: titlecontroller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Note Title",
              ),
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TextField(
                controller: contentcontroller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "your note",
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            titleEdited = titlecontroller.text;
            contentEdited = contentcontroller.text;
            _showMyDialog();
          });
        },
        label: Text("Save Note"),
        icon: Icon(Icons.save),
      ),
    );
  }
}
