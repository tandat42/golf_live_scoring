import 'package:firebase_core/firebase_core.dart';
import 'package:golf_live_scoring/core/common/initializable.dart';
import 'package:golf_live_scoring/firebase_options.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class MainService with Initializable {
  Future<void> init() async {
    if (initialized) return;

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    initialized = true;
  }
}
