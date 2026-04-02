import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Note> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('http://localhost:5171'),
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Note.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load notes');
  }
}

class Note {
  final int id;
  final String inhalt;
  final String title;

  const Note({required this.id, required this.inhalt, required this.title});

  factory Note.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'inhalt':String inhalt, 'title': String title} => Note(
        id: id,
        inhalt: inhalt,
        title: title,
      ),
      _ => throw const FormatException('Failed to load notes.'),
    };
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Note> futureNote;

  @override
  void initState() {
    super.initState();
    futureNote = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Fetch Data Example')),
        body: Center(
          child: FutureBuilder<Note>(
            future: futureNote,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

}
