import 'package:flutter/material.dart';
import 'package:todo_app/screens/NotesScreesn.dart';
import 'package:todo_app/screens/add_note.dart';
import 'package:todo_app/screens/display_note.dart';
import 'package:todo_app/screens/update_note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesScreen(),
      routes: {
        AddNoteScreen.routename: (ctx) => AddNoteScreen(),
        ShowNote.routename: (ctx) => ShowNote(),
        UpdateNoteScreen.routename: (ctx) => UpdateNoteScreen(),
      },
    );
  }
}
