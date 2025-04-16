import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:golf_live_scoring/core/data/field.dart';
import 'package:golf_live_scoring/core/data/profile.dart';
import 'package:golf_live_scoring/core/data/setup.dart';
import 'package:golf_live_scoring/core/data/tournament.dart';
import 'package:golf_live_scoring/core/services/initializable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@Singleton()
class DataService with Initializable {
  DataService();

  static const _setupKey = 'setup';
  static const _profilesKey = 'profiles';
  static const _fieldsKey = 'fields';
  static const _tournamentsKey = 'tournaments';

  late final _db = FirebaseFirestore.instance;

  late final _setupSubject = BehaviorSubject<Setup>();
  late final _profileSubject = BehaviorSubject<Profile>();

  Stream<Setup> get setupStream => _setupSubject.stream;

  Setup get setup => _setupSubject.value;

  Stream<Profile?> get profileStream => _profileSubject.stream;

  Profile? get profile => _profileSubject.valueOrNull;

  User? get _user => FirebaseAuth.instance.currentUser;

  Future<void> init() async {
    if (initialized) return;

    if (_setupSubject.valueOrNull == null) await loadSetup();
    await loadProfile();

    initialized = true;
  }

  Future<Setup> loadSetup() async {
    final doc = await _db.collection(_setupKey).doc(_setupKey).get();
    final setup = Setup.fromJson(doc.data() ?? {});
    _setupSubject.add(setup);
    return setup;
  }

  Future<void> editProfile(Profile profile) async {
    await _db.collection(_profilesKey).doc(_user!.uid).set(profile.toJson());
    _profileSubject.add(profile);
  }

  Future<Profile?> loadProfile() async {
    if (_user == null) return null;

    final doc = await _db.collection(_profilesKey).doc(_user!.uid).get();
    final profile = Profile.fromJson(doc.data() ?? {}).copyWith(id: _user!.uid);
    _profileSubject.add(profile);
    return profile;
  }

  Future<List<Profile>> loadProfiles() async {
    final col = await _db.collection(_profilesKey).get();
    return col.docs.map((d) => Profile.fromJson(d.data()).copyWith(id: d.id)).toList();
  }

  Future<List<Field>> loadFields() async {
    final col = await _db.collection(_fieldsKey).get();
    return col.docs.map((d) => Field.fromJson(d.data()).copyWith(id: d.id)).toList();
  }

  Future<List<Tournament>> loadTournaments() async {
    final col = await _db.collection(_tournamentsKey).get();
    return col.docs.map((d) => Tournament.fromJson(d.data())).toList();
  }

  Future<Tournament> loadTournament(String id) async {
    final doc = await _db.collection(_tournamentsKey).doc(id).get();
    return Tournament.fromJson(doc.data() ?? {});
  }

  Stream<Tournament?> listenTournament(String id) {
    return _db.collection(_tournamentsKey).doc(id).snapshots().map((s) {
      final data = s.data();
      return data != null ? Tournament.fromJson(data) : null;
    });
  }
}
