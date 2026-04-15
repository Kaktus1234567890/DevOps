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
        title: Text("Update Note"),
        content: IntrinsicHeight(
          child: Column(
            spacing: 10,
            children: [
              TextField(
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Titel',
                ),
                controller: TextEditingController(text: widget._titel),
                onChanged: (data) => neuerTitel = data,
                onSubmitted: (data)  {
                  updateNote(widget._id, neuerInhalt, neuerTitel);
                  Navigator.pop(context);
                },
              ),
              TextField(
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Inhalt',
                ),
                controller: TextEditingController(text: widget._inhalt),
                onChanged: (data) => neuerInhalt = data,
                onSubmitted: (data)  {
                  updateNote(widget._id, neuerInhalt, neuerTitel);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
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
      child: IntrinsicHeight(
        child: Row(
          children: <Widget> [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Container(child: Text(widget._titel, style: TextStyle(fontWeight: FontWeight.bold),textScaler: TextScaler.linear(1.3),))),
                    Container(child: Text(widget._inhalt)),
                  ],
                ),
              ),
            ),
            const VerticalDivider(
              color: Colors.black
            ),
            Container(
              child: Column(
                children: [
                  Expanded(child: Container(),),
                  _deleting?
                  IconButton(onPressed: () => setState(() {
                    _deleting = false;
                  }), icon: Icon(Icons.close), tooltip: "Cancel",) :
                  IconButton(onPressed: () => setState(() {
                    _deleting = true;
                  }), icon: Icon(Icons.delete), tooltip: "Delete Note",)
                  ,
                  _deleting?
                  IconButton(onPressed: _delete, icon: Icon(Icons.check), tooltip: "Delete Note",) :
                  IconButton(onPressed: _update, icon: Icon(Icons.edit), tooltip: "Edit Note",)
                  ,
                  Expanded(child: Container(),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int get id => widget._id;

  String get titel => widget._titel;

  String get inhalt => widget._inhalt;
}
