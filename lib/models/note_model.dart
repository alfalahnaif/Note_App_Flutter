class NoteModel {
  final id;
  final String title;
  final String content;

  NoteModel({this.id, required this.title, required this.content});

  Map<String, dynamic> toMap() {
    return ({"id": id, "title": title, "content": content});
  }
}
