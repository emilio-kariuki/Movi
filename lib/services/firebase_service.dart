import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:stacked/stacked.dart';
import '../models/user_model.dart';
import '../models/user_movies.dart';

class FirebaseService with ReactiveServiceMixin {
  final _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  List<UserMovies> _userFilms = [];

  User? get currentUser => _currentUser;
  List<UserMovies> get userFilms => List.unmodifiable(_userFilms);

  Future<void> createUser({required User user}) async {
    await _firestore
        .collection('user')
        .doc(user.id)
        .set(user.toJson(), SetOptions(merge: true));
    _currentUser = user;
    notifyListeners();
  }

  Future<void> loadUser({required String id}) async {
    final doc = await _firestore.collection('user').doc(id).get();
    _currentUser = User.fromJson(doc.data()!);
    notifyListeners();
  }

  Future<void> updateUser({required User user}) async {
    await _firestore.collection('user').doc(user.id).update(user.toJson());
    _currentUser = user;
    notifyListeners();
  }

  Future<void> deleteUser({required String id}) async {
    await _firestore.collection('user').doc(id).delete();
    await fb.FirebaseAuth.instance.currentUser?.delete();
    _currentUser = null;
    _userFilms = [];
    notifyListeners();
  }

  Future<void> loadUserFilms({required String id}) async {
    final snapshot = await _firestore
        .collection('films')
        .where('belongsTo', isEqualTo: id)
        .get();
    _userFilms =
        snapshot.docs.map((e) => UserMovies.fromJson(e.data())).toList();
    notifyListeners();
  }

  Future<void> addUserFilm({required UserMovies movie}) async {
    await _firestore
        .collection('films')
        .doc(movie.id.toString())
        .set(movie.toJson(), SetOptions(merge: true));
    if (!_userFilms.any((f) => f.id == movie.id)) {
      _userFilms = [..._userFilms, movie];
    }
    notifyListeners();
  }

  Future<void> deleteUserFilm({required String filmId}) async {
    await _firestore.collection('films').doc(filmId).delete();
    _userFilms = _userFilms.where((f) => f.id.toString() != filmId).toList();
    notifyListeners();
  }

  bool isFilmFavourited(int id) => _userFilms.any((f) => f.id == id);
}
