import 'package:flutter/material.dart';
import 'package:new_begining/services/auth/auth_services.dart';
import 'package:new_begining/services/crud/notes_services.dart';

class NewNotView extends StatefulWidget {
  const NewNotView({super.key});

  @override
  State<NewNotView> createState() => _NewNotView();
}

class _NewNotView extends State<NewNotView> {
  DatabaseNotes? _note;
  late final NotesServices _notesServices;
  late final TextEditingController _textEditingController;

  // create new note
  Future<DatabaseNotes> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      // if note is not null
      return existingNote;
    }
    // if note is null, create note
    final currentUser = AuthServices.firebase().currentUser!;
    final email = currentUser.email;
    final owner = await _notesServices.getUser(email: email);
    return await _notesServices.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      _notesServices.deleteNote(id: note.id);
    }
  }

  void _saveNotesIfTextNotEmpty() async {
    final note = _note;
    final text = _textEditingController.text;
    if (note != null && text.isNotEmpty) {
      await _notesServices.updateNote(note: note, text: text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: Padding(
        padding: EdgeInsetsGeometry.all(8.0),
        child: const Text('Wait'),
      ),
    );
  }
}
