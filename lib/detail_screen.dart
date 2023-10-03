import 'package:flutter/material.dart';
import 'package:notesapp/model/note.dart';

class DetailScreen extends StatelessWidget {
  final Note note;
  final void Function(int, String, String) editNote;

  final TextEditingController _titleController;
  final TextEditingController _bodyController;

  DetailScreen({Key? key, required this.note, required this.editNote})
      : _titleController = TextEditingController(text: note.title),
        _bodyController = TextEditingController(text: note.body),
        super(key: key);

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
                      'Edit Note',
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
                        editNote(note.id, _titleController.text,
                            _bodyController.text);
                        Navigator.pop(context);
                      },
                      child: const Text('Edit'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(note.title,
                    style:
                        const TextStyle(fontSize: 30.0, color: Colors.black)),
              ),
              const SizedBox(height: 6.0),
              Center(
                child: Text(note.date,
                    style:
                        const TextStyle(fontSize: 14.0, color: Colors.black54)),
              ),
              const SizedBox(height: 16.0),
              Text(note.body,
                  style: const TextStyle(fontSize: 14.0, color: Colors.black)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteModal(context),
        child: const Icon(Icons.edit),
      ),
    );
  }
}
