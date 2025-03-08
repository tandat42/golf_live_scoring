import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:golf_live_scoring/core/data/club.dart';
import 'package:golf_live_scoring/core/data/clubs.dart';
import 'package:golf_live_scoring/core/data/profile.dart';
import 'package:golf_live_scoring/core/services/initializable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@Singleton()
class DataService with Initializable {
  DataService();

  static const _setupKey = 'setup';
  static const _profilesKey = 'profiles';
  static const _clubsKey = 'clubs';

  late final _db = FirebaseFirestore.instance;

  late final _profileSubject = BehaviorSubject<Profile>();

  Stream<Profile?> get profileStream => _profileSubject.stream;

  Profile? get profile => _profileSubject.value;

  User? get _user => FirebaseAuth.instance.currentUser;

  Future<void> init() async {
    if (initialized) return;

    await getProfile();

    initialized = true;
  }

  Future<List<Club>> getClubs() async {
    final doc = await _db.collection(_setupKey).doc(_clubsKey).get();
    final data = doc.data();
    if (data == null) return [];
    return Clubs.fromJson(data).clubs ?? [];
  }

  Future<void> editProfile(Profile profile) async {
    await _db.collection(_profilesKey).doc(_user!.uid).set(profile.toJson());
    _profileSubject.add(profile);
  }

  Future<Profile?> getProfile() async {
    if (_user == null) return null;

    final doc = await _db.collection(_profilesKey).doc(_user!.uid).get();
    final data = doc.data();
    final profile = data == null ? Profile() : Profile.fromJson(data);
    _profileSubject.add(profile);
    return profile;
  }
}
