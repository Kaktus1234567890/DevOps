import 'package:devops_projekt/network.dart';
import 'package:flutter/material.dart';


class NoteListProvidor /*Singleton*/ with ChangeNotifier{
  NoteListProvidor._privateConstructor();
  static final NoteListProvidor _instance = NoteListProvidor._privateConstructor();

  factory NoteListProvidor(){
    return _instance;
  }

  List<Note> _noteList = List<Note>.empty(growable: true);

  List<Note> get noteList => _noteList;

  set noteList(List<Note> value) {
    _noteList = value;
    notifyListeners();
  }
}

class Note extends StatefulWidget with ChangeNotifier {
  Note(this._id, this._titel, this._inhalt, {super.key});

  final int _id;
  final String _titel;
  final String _inhalt;

  factory Note.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'titel': String title, 'inhalt': String inhalt} => Note(
        id,
        title,
        inhalt,
      ),
      _ => throw const FormatException('Failed to format notes.'),
    };
  }

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  
  bool _deleting = false;
  
  void _delete() {
    deleteNote(id);
  }

  void _update() {
    String neuerTitel = titel;
    String neuerInhalt = inhalt;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Titel',
              ),
              controller: TextEditingController(text: widget._titel),
              onChanged: (data) => neuerTitel = data,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Inhalt',
              ),
              controller: TextEditingController(text: widget._inhalt),
              onChanged: (data) => neuerInhalt = data,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              updateNote(widget._id, neuerInhalt, neuerTitel);
              Navigator.pop(context);
            },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: BoxBorder.all()),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Container(child: Text(widget._titel)),
                  Container(child: Text(widget._inhalt)),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(left: BorderSide())),
            child: Column(
              children: [
                _deleting?
                IconButton(onPressed: () => _deleting = true, icon: Icon(Icons.delete)) :
                IconButton(onPressed: () => _deleting = false, icon: Icon(Icons.close))
                ,
                _deleting?
                IconButton(onPressed: _update, icon: Icon(Icons.edit)) :
                IconButton(onPressed: _delete, icon: Icon(Icons.check))
                ,
              ],
            ),
          ),
        ],
      ),
    );
  }

  int get id => widget._id;

  String get titel => widget._titel;

  String get inhalt => widget._inhalt;
}
