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
