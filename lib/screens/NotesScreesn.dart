import 'package:flutter/material.dart';
import 'package:todo_app/db/database_model.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/screens/add_note.dart';
import 'package:todo_app/screens/display_note.dart';
import 'package:todo_app/screens/update_note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);
  static String routename = "/notescreen";

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // ignore: non_constant_identifier_names
  final db = DatabaseModel.instance;
  final titleEdites = "";
  final contentEdited = "";
  var mynotes = [];
  List<Widget> children = [];

  Future<bool> query() async {
    mynotes = [];
    children = [];
    var allNotes = await db.queryAll();
    allNotes?.forEach((note) {
      mynotes.add(note.toString());
      children.add(Card(
        elevation: 5.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            title: Text(
              note['title'], // Value
              style: const TextStyle(fontSize: 18.0),
            ),
            subtitle: Text(
              note['content'],
              style: const TextStyle(fontSize: 18.0),
            ),
            onTap: () {
              int noteid = note['id'];
              String notetitle = note['title'];
              String notecontent = note['content'];
              Navigator.of(context).pushNamed(ShowNote.routename,
                  arguments: NoteModel(
                      title: notetitle, content: notecontent, id: noteid));
            },
            trailing: FlatButton(
              child: Icon(Icons.update),
              onPressed: () {
                int noteid = note['id'];
                String notetitle = note['title'];
                String notecontent = note['content'];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateNoteScreen(
                              id: noteid,
                              title: notetitle,
                              content: notecontent,
                            )));
              },
            ),
          ),
        ),
      ));
    });
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AddNoteScreen.routename);
          },
          child: Icon(Icons.add)),
      appBar: AppBar(
        title: const Text("Your Notes"),
      ),
      body: FutureBuilder(
          future: query(),
          builder: (context, snap) {
            if (snap.hasData == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (mynotes.length == 0) {
                return const Center(
                  child: Text("You don't have any notes yet, create one now"),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: children,
                  ),
                );
              }
            }
          }),
    );
  }
}
