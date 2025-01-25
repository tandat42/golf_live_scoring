import 'package:flutter/foundation.dart';
import 'package:golf_live_scoring/core/services/auth/mobile_google_sign_in_resolver.dart';
import 'package:golf_live_scoring/core/services/auth/web_google_sign_in_resolver.dart';
import 'package:injectable/injectable.dart';

abstract class GoogleSignInResolver {
  Future<void> init() async {}

  Future<void> signIn();
}

@module
abstract class GoogleSignInResolverDi {
  @injectable
  GoogleSignInResolver get platformService {
    if (!kIsWeb) {
      return MobileGoogleSignInResolver();
    } else {
      return WebGoogleSignInResolver();
    }
  }
}
