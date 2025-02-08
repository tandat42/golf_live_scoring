import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.dart';
import 'package:golf_live_scoring/ui/screens/main/main_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class MainCubit extends Cubit<MainState> {
  MainCubit(this._router) : super(MainState());

  final GolfRouter _router;

  late FirebaseFirestore db;

  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listen;

  final picker = ImagePicker();

  late int counter;

  Future<void> init() async {
    db = FirebaseFirestore.instance;
    listen = db.collection('test_data').doc(FirebaseAuth.instance.currentUser!.uid).snapshots().listen(
        (DocumentSnapshot snapshot) {
      var updatedCoutner = (snapshot.data() as Map<String, dynamic>?)?['counter'] ?? -1;
      emit(state.copyWith(counter: updatedCoutner));
      counter = updatedCoutner;
    }, onError: (e) => emit(state.copyWith(exception: e)));
  }

  @override
  Future<void> close() {
    listen.cancel();

    return super.close();
  }

  void upCounter() {
    db.collection('test_data').doc(FirebaseAuth.instance.currentUser!.uid).set({'counter': ++counter});
  }

  Future<void> scanData() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {}
  }
}
