import 'dart:convert';
import 'note.dart';
import 'package:http/http.dart' as http;

const String url = 'http://localhost:5171/api/Notes';

Future<http.Response> networkdeleteNote(int id) async {
  final http.Response response = await http.delete(
    Uri.parse('$url/$id'),

    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  return response;
}

Future<http.Response> networkupdateNote(int id, String inhalt, String titel) async {
  final http.Response response = await http.put(
    Uri.parse('$url/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id': id,
      'titel': titel,
      'inhalt': inhalt,
    }),
  );
  return response;
}

Future<http.Response> networkcreateNote(String inhalt, String titel) async {
  final http.Response response = await http.post(
    Uri.parse('$url/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'titel': titel, 'inhalt': inhalt}),
  );
  return response;
}

Future<List<Note>> networkgetAllNotes() async {
  final http.Response response =  await http.get(
    Uri.parse('$url/all'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> dataList = jsonDecode(response.body);
    List<Note> noteList = List<Note>.empty(growable: true);

    for (var dataObject in dataList) {
      noteList.add(Note.fromJson(dataObject));
    }

    return noteList;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<void> deleteNote(int id) async {
  await networkdeleteNote(id);
  NoteListProvidor().noteList = await networkgetAllNotes();
}

Future<void> updateNote(int id, String inhalt, String titel) async {
  await networkupdateNote(id, inhalt, titel);
  NoteListProvidor().noteList = await networkgetAllNotes();
}

Future<void> createNote (String inhalt, String titel) async {
  await networkcreateNote(inhalt, titel);
  NoteListProvidor().noteList = await networkgetAllNotes();
}

Future<void> refreshNotelist() async {
  NoteListProvidor().noteList = await networkgetAllNotes();
  return;
}