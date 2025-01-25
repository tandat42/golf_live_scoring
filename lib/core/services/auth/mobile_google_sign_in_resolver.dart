import 'package:firebase_auth/firebase_auth.dart';
import 'package:golf_live_scoring/core/services/auth/google_sign_in_resolver.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MobileGoogleSignInResolver extends GoogleSignInResolver {
  @override
  Future<void> signIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
