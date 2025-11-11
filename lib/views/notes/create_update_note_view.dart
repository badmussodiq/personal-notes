// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_begining/services/auth/auth_services.dart';
import 'package:new_begining/services/crud/cloud_notes_storage_services.dart';
import 'package:new_begining/services/crud/firebase_cloud_storage.dart';
// import 'package:new_begining/services/crud/local_notes_services.dart';
import 'dart:developer' as devtool show log;

import 'package:new_begining/utilities/generics/get_arguments.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteView();
}

class _CreateUpdateNoteView extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesServices;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _notesServices = FirebaseCloudStorage();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;
    await _notesServices.updateNote(
      documentId: note.documentId,
      text: text,
    );
    // await _notesServices.updateNote(note: note, text: text);
  }

  void _setupTextControllerListener() {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }

  // create new note
  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    _note = context.getArgument<CloudNote>();

    if (_note != null) {
      // _note = widgetNote;
      _textEditingController.text = _note!.text;
      return _note!;
    }

    devtool.log("Creating a note");
    final existingNote = _note;
    if (existingNote != null) {
      // if note is not null
      return existingNote;
    }
    // if note is null, create note
    final currentUser = AuthServices.firebase().currentUser!;
    // final email = currentUser.email;

    _note = await _notesServices.createNewNote(
      ownerUserId: currentUser.id,
      text: '',
    );
    // final owner = await _notesServices.getUser(email: email);
    // _note = await _notesServices.createNote(owner: owner);
    return _note!;
  }

  void _deleteNoteIfTextIsEmpty() {
    devtool.log("deleting not if text is empty");
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      devtool.log('deleting note progress');
      _notesServices.deleteNote(documentId: note.documentId);
      // _notesServices.deleteNote(id: note.id);
    }
  }

  void _saveNotesIfTextNotEmpty() async {
    devtool.log("save not if text not empty");
    final note = _note;
    final text = _textEditingController.text;
    if (note != null && text.isNotEmpty) {
      devtool.log('saving not if text is not empty');
      await _notesServices.updateNote(documentId: note.documentId, text: text);
      // await _notesServices.updateNote(note: note, text: text);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNotesIfTextNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.done:
              // _note = asyncSnapshot.data as DatabaseNotes;
              _setupTextControllerListener();
              return Padding(
                padding: EdgeInsetsGeometry.all(8.0),
                child: TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Start typing your note...',
                  ),
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
