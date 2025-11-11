import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_begining/constants/cloud_storage_constants.dart';
import 'package:new_begining/exceptions/custom_exceptions.dart';
import 'package:new_begining/services/crud/cloud_notes_storage_services.dart';

class FirebaseCloudStorage {
  // collection reference for notes from firebase firestore
  final notes = FirebaseFirestore.instance.collection(notesCollectionName);

  // singleton instance of the class FirebaseCloudStorage that handles firebase cloud storage operations for notes collection
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map(
        (event) => event.docs
            .map((doc) => CloudNote.fromSnapshot(doc))
            .toList()
            .where((note) => note.ownerUserId == ownerUserId),
      );

  // Stream<Iterable<CloudNote>> allNotes1({required String ownerUserId}) =>
  //     notes
  //         .where(
  //           ownerUserIdFieldName,
  //           isEqualTo: ownerUserId,
  //         )
  //         .snapshots()
  //         .map(
  //           (event) => event.docs
  //               .map(
  //                 (doc) => CloudNote(
  //                   documentId: doc.id,
  //                   ownerUserId:
  //                       doc.data()[ownerUserIdFieldName] as String,
  //                   text: doc.data()[textFieldName] as String,
  //                 ),
  //               )
  //               .toList(),
  //         );

  // private constructor
  FirebaseCloudStorage._sharedInstance();

  // singleton factory constructor
  factory FirebaseCloudStorage() => _shared;

  // create a new note in the notes collection
  Future<CloudNote> createNewNote({
    required String ownerUserId,
    required String text,
  }) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: text,
    });

    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: text,
    );
  }

  // get all notes for a specific user from the notes collection
  Future<Iterable<CloudNote>> getAllUsersNotes({
    required String ownerUserId,
  }) async {
    try {
      final allNotes = await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get();
      final notesList = allNotes.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .toList();
      return notesList;
    } catch (e) {
      throw CouldNotGetAllNotesException("Failed to get all notes: $e");
    }
  }

  // update an existing note in the notes collection
  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException("Failed to update note: $e");
    }
  }

  // delete a note from the notes collection
  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException("Failed to delete note: $e");
    }
  }
}
