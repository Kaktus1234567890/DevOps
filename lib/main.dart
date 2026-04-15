import 'args.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'network.dart';
import 'note.dart';

void main() {
  print(NetworkService.port);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _addNote() {
    String titel = "";
    String inhalt = "";

    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: Text("Create Note"),
            content: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Titel',
                  ),
                  onChanged: (data) => titel = data,
                  onSubmitted: (data)  {
                    createNote(inhalt, titel);
                    Navigator.pop(context);
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Inhalt',
                  ),
                  onChanged: (data) => inhalt = data,
                  onSubmitted: (data)  {
                    createNote(inhalt, titel);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  createNote(inhalt, titel);
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    refreshNotelist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ListenableBuilder(
            listenable: NoteListProvidor(),
            builder: (BuildContext context, Widget? child) {
              return ListView(children: (NoteListProvidor().noteList));
            },
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Create Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
