class DatabaseNotOpenException implements Exception {
  final String message;
  DatabaseNotOpenException(this.message);
}

class DatabaseAlreadyOpenException implements Exception {
  final String message;
  DatabaseAlreadyOpenException(this.message);
}

class CouldNotFoundUserException implements Exception {
  final String message;
  CouldNotFoundUserException(this.message);
}

class CloudStorageException implements Exception {
  final String message;
  CloudStorageException(this.message);

  @override
  String toString() => 'CloudStorageException :=> $message';
}

class CouldNotCreateNoteException extends CloudStorageException {
  CouldNotCreateNoteException([super.message = 'Could not create note.']);
}

class CouldNotGetAllNotesException extends CloudStorageException {
  CouldNotGetAllNotesException([super.message = 'Could not get all notes.']);
}

class CouldNotUpdateNoteException extends CloudStorageException {
  CouldNotUpdateNoteException([super.message = 'Could not update note.']);
}

class CouldNotDeleteNoteException extends CloudStorageException {
  CouldNotDeleteNoteException([super.message = 'Could not delete note.']);
}
