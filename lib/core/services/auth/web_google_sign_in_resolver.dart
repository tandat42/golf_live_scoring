import 'package:firebase_auth/firebase_auth.dart';
import 'package:golf_live_scoring/core/services/auth/google_sign_in_resolver.dart';

class WebGoogleSignInResolver extends GoogleSignInResolver {
  late final GoogleAuthProvider _authProvider;

  @override
  Future<void> init() async {
    _authProvider = GoogleAuthProvider();

    _authProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  }

  @override
  Future<void> signIn() async {
    await FirebaseAuth.instance.signInWithPopup(_authProvider);
  }
}
