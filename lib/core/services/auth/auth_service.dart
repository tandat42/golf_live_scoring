import 'package:firebase_auth/firebase_auth.dart';
import 'package:golf_live_scoring/core/exceptions/sign_in_exception.dart';
import 'package:golf_live_scoring/core/services/auth/google_sign_in_resolver.dart';
import 'package:golf_live_scoring/core/services/initializable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@Singleton()
class AuthService with Initializable {
  AuthService(this._googleSignInResolver);

  late final auth = FirebaseAuth.instance;
  late final GoogleSignInResolver _googleSignInResolver;

  late final _authProgressSubject = BehaviorSubject<bool>();
  late final _userSubject = BehaviorSubject<User?>();

  Stream<bool> get authProgressStream => _authProgressSubject.stream;

  Stream<User?> get userStream => _userSubject.stream;

  Future<void> init() async {
    if (initialized) return;

    _googleSignInResolver.init();

    _authProgressSubject.add(false);
    _userSubject.add(auth.currentUser);

    auth.authStateChanges().listen((User? user) => _updateUser(user));

    initialized = true;
  }

  bool isSignedIn() {
    return _userSubject.value != null;
  }

  User? getUser() {
    return _userSubject.value;
  }

  void _updateUser(User? user) {
    _userSubject.add(user);
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
      _userSubject.add(null);
    });
  }

  Future<void> _makeAuthAction(Future<void> Function() action) async {
    if (_authProgressSubject.value) throw SignInInProgressException();

    _authProgressSubject.add(true);
    try {
      await action.call();
    } finally {
      _updateUser(FirebaseAuth.instance.currentUser);
      _authProgressSubject.add(false);
    }
  }
}
