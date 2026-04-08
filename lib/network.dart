import 'dart:convert';

import 'package:devops_projekt/note.dart';
import 'package:http/http.dart' as http;

const String url =  'http://localhost:5171/api/Notes';

Future<http.Response> deleteNote(int id) async {
  final http.Response response = await http.delete(
    Uri.parse('$url/$id'),

    headers: <String, String>{
      'Content-Type':  'charset=UTF-8',
    },
  );

  return response;
}

Future<http.Response> updateNote(int id, String inhalt, String titel) async {
  return http.put(
    Uri.parse('$url/one?id=$id'),
    headers: <String, String>{
      'Content-Type':  'charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id': id,
      'titel' : titel,
      'inhalt' : inhalt
    }),
  );
}

Future<http.Response> createNote(String inhalt, String titel) async {
  return http.post(
    Uri.parse('$url/'),
    headers: <String, String>{
      'Content-Type':  'charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'titel' : titel,
      'inhalt' : inhalt
    }),
  );
}

void getAllNotes() async {
  final response = await http.get(
    Uri.parse('$url/all'),
    headers: <String, String>{
      'Content-Type':  'charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> dataList = jsonDecode(response.body);
    List<Note> noteList = List<Note>.empty(growable: true);

    for (var dataObject in dataList)
      {
        noteList.add(Note.fromJson(dataObject));
      }

    Note.noteList = noteList;
    return;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}