class SignUpException implements Exception {
  SignUpException({this.baseException});

  Exception? baseException;
}
