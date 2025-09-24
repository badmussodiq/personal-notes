import 'package:flutter/material.dart';
import 'package:new_begining/services/crud/notes_services.dart';
import 'package:new_begining/utilities/dialogs/show_delete_dialog.dart';

/// This is a callback function in dart programming
/// This function returns void, but it actually does
/// something in the implementation.
/// The function is a a type definintion not the implementation itself
typedef NoteCallback = void Function(DatabaseNotes note);

/// This view is a component, that renders a single text view to the user
/// This view is a stateless widget
class NotesListView extends StatelessWidget {
  final List<DatabaseNotes> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;
  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            // note.text,
            note.text.isEmpty ? 'Empty Note' : note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              // show delete dialog
              final shouldDelete = await showDeleteDialog(context);

              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: Icon(
              Icons.delete,
              // color: Color(const Color.fromARGB(0, 0, 0, 0).hashCode),
            ),
          ),
          subtitle: Text('Synced: ${note.isSyncedWithCloud}'),
        );
      },
    );
  }
}
