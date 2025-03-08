class SignInException implements Exception {
  SignInException({this.baseException});

  Exception? baseException;
}

class SignInInProgressException {}
