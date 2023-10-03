import 'package:flutter/material.dart';
import 'package:notesapp/model/note.dart';
import 'package:notesapp/detail_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  final notes = <Note>[];

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _searchController = TextEditingController();

  void _addNotes(String title, String body) {
    setState(() {
      notes.add(
        Note(
            id: notes.length + 1,
            title: title,
            body: body,
            date: DateTime.now().toString().substring(0, 10)),
      );
    });
  }

  void _deleteNote(int id) {
    setState(() {
      notes.removeWhere((element) => element.id == id);
    });
  }

  void editNote(int id, String title, String body) {
    setState(() {
      int noteIndex = notes.indexWhere((note) => note.id == id);

      if (noteIndex != -1) {
        Note updatedNote = Note(
          id: id,
          title: title,
          body: body,
          date: DateTime.now().toString().substring(0, 10),
        );

        notes[noteIndex] = updatedNote;
      }
    });
  }

  void _showAddNoteModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Add Note',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _bodyController,
                      decoration: const InputDecoration(
                        hintText: 'Body',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _addNotes(_titleController.text, _bodyController.text);
                        _titleController.clear();
                        _bodyController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var filteredNote = notes.where((note) {
      return note.title.toLowerCase().contains(_searchController.text) ||
          note.date.toLowerCase().contains(_searchController.text);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Notes App")),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search',
            ),
            onChanged: (String value) {
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: filteredNote.isEmpty
              ? const Center(
                  child: Text(
                  'No Notes',
                  style: TextStyle(fontSize: 24.0),
                ))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final note = filteredNote[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DetailScreen(
                            note: note,
                            editNote: editNote,
                          );
                        }));
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(note.title),
                          subtitle: Text(note.date),
                          trailing: IconButton(
                            onPressed: () {
                              _deleteNote(
                                note.id,
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red, // set the color to red
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: filteredNote.length,
                ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
