import 'package:firebase_auth/firebase_auth.dart';
import 'package:golf_live_scoring/core/common/initializable.dart';
import 'package:golf_live_scoring/core/data/auth_status.dart';
import 'package:golf_live_scoring/core/data/exceptions/sign_in_exception.dart';
import 'package:golf_live_scoring/core/services/auth/google_sign_in_resolver.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@Singleton()
class AuthService with Initializable {
  AuthService(this._googleSignInResolver);

  final GoogleSignInResolver _googleSignInResolver;

  late final BehaviorSubject<AuthStatus> _signedInStatusSubject;

  Stream<AuthStatus> get signedInStatusStream => _signedInStatusSubject.stream;

  Future<void> init() async {
    if (initialized) return;

    _googleSignInResolver.init();

    _signedInStatusSubject = BehaviorSubject<AuthStatus>.seeded(
        FirebaseAuth.instance.currentUser != null ? AuthStatus.unsigned : AuthStatus.signed);
    FirebaseAuth.instance.authStateChanges().listen((User? user) => _updateSignInStatus(user));

    initialized = true;
  }

  bool isSignedIn() {
    return _signedInStatusSubject.value == AuthStatus.signed;
  }

  bool isEmailVerified() {
    return _signedInStatusSubject.value == AuthStatus.signed;
  }

  void _updateSignInStatus(User? user) {
    _signedInStatusSubject.add(user != null ? AuthStatus.signed : AuthStatus.unsigned);
  }

  Future<void> signUpWithEmail(String email, String password) {
    return _makeAuthAction(() async {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signInWithEmail(String email, String password) {
    return _makeAuthAction(() async {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signInWithGoogle() {
    return _makeAuthAction(() async {
      await _googleSignInResolver.signIn();
    });
  }

  Future<void> signOut() {
    return _makeAuthAction(() async {
      await FirebaseAuth.instance.signOut();
    });
  }

  Future<void> _makeAuthAction(Future<void> Function() action) async {
    if (_signedInStatusSubject.value == AuthStatus.inProgress) throw SignInInProgressException();

    _signedInStatusSubject.add(AuthStatus.inProgress);
    try {
      await action.call();
    } finally {
      _updateSignInStatus(FirebaseAuth.instance.currentUser);
    }
  }
}
