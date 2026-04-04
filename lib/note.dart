import 'package:devops_projekt/network.dart';
import 'package:flutter/material.dart';

class Note extends StatefulWidget
{
  const Note(this._id, this._titel, this._inhalt, {super.key});

  final int _id;
  final String _titel;
  final String _inhalt;
  static List<Note> noteList = List<Note>.empty(growable : true);

  factory Note.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'titel': String title, 'inhalt':String inhalt} => Note(
        id,
        title,
        inhalt
      ),
      _ => throw const FormatException('Failed to format notes.'),
    };
  }

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  void _delete()
  {
    deleteNote(id);
    setState(() async {
      Note.noteList = await getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child:
      Row(
        children: [
          Column(
            children: [
              IconButton(
                  onPressed: _delete,
                  icon: Icon(Icons.delete)
              ),
              IconButton(
                  onPressed: () {
                    String neuerTitel = "";
                    String neuerInhalt = "";
                    showDialog(context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Titel',
                                ),
                                controller: TextEditingController(text: widget._titel),
                                onSubmitted: (data) => neuerTitel = data,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Inhalt',
                                ),
                                controller: TextEditingController(text: widget._inhalt),
                                onSubmitted: (data) => neuerInhalt = data,
                              )

                            ],
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                            TextButton(onPressed: () {
                              setState(() async {
                                await updateNote(widget._id, neuerInhalt, neuerTitel);
                                Note.noteList = await getAllNotes();
                              });
                              Navigator.pop(context);
                            }, child: Text("Ok"))
                          ],
                        )
                    );
                  },
                  icon: Icon(Icons.edit)
              ),
              IconButton(
                  onPressed: () {
                    setState(() async {
                      await updateNote(widget._id, widget._inhalt, widget._titel);
                      Note.noteList = await getAllNotes();
                    });
                  },
                  icon: Icon(Icons.save)
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child:
                Text(widget._titel),
              ),
              Container(
                child:
                Text(widget._inhalt),
              )
            ],
          )
        ],
      ),
    );
  }

  int get id => widget._id;

  String get titel => widget._titel;

  String get inhalt => widget._inhalt;
}