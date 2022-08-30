import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/db/database_model.dart';
import 'package:todo_app/models/note_model.dart';

import 'NotesScreesn.dart';

class UpdateNoteScreen extends StatefulWidget {
  const UpdateNoteScreen({Key? key, this.title, this.content, this.id})
      : super(key: key);
  static String routename = "/updatenotescreen";
  final id;
  final title;
  final content;
  @override
  State<UpdateNoteScreen> createState() => _UpdateNoteScreenState();
}

class _UpdateNoteScreenState extends State<UpdateNoteScreen> {
  final db = DatabaseModel.instance;
  var titleEdited;
  var contentEdited;
  late TextEditingController titlecontroller;
  late TextEditingController contentcontroller;

  void updateNotes() async {
    NoteModel note =
        NoteModel(title: titleEdited, content: contentEdited, id: widget.id);
    final upd = await db.updateNote(note, note.id);
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
                // addNote();
                updateNotes();
                Navigator.of(context).pop();
                Fluttertoast.showToast(
                    msg: "Note Updated Successfully",
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
  void initState() {
    // TODO: implement initState
    super.initState();
    titlecontroller = TextEditingController();
    contentcontroller = TextEditingController();
    titlecontroller.text = widget.title;
    contentcontroller.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            TextField(
              controller: titlecontroller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Note Title",
              ),
              style:
                  const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TextField(
                controller: contentcontroller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
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
        label: Text("Update Note"),
        icon: Icon(Icons.save),
      ),
    );
  }
}
