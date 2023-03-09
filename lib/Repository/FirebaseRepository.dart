import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:movi/models/UserFilmsModel.dart';
import 'package:movi/models/UserModel.dart';
import 'package:movi/models/UserMovies.dart';

class FirebaseRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;

   createUser({required User user}) async {
    await _firebaseFirestore
        .collection('user')
        .doc(user.id)
        .set(user.toJson(), SetOptions(merge: true));
  }

  Future<User> getUser({required String id}) async {
    var user = await _firebaseFirestore.collection('user').doc(id).get();
    return User.fromJson(user.data()!);
  }

   updateUser({required User user}) async {
    await _firebaseFirestore
        .collection('user')
        .doc(user.id)
        .update(user.toJson());
  }

   deleteUser({required String id}) async {
    await _firebaseFirestore.collection('user').doc(id).delete();
    await auth.FirebaseAuth.instance.currentUser!.delete();
  }

   Future<List<UserMovies>> getUserFilms({required String id}) async {
    var userFilms = await _firebaseFirestore
        .collection('films')
        .where('belongsTo', isEqualTo: id)
        .get();
    return userFilms.docs
        .map((e) => UserMovies.fromJson(e.data()))
        .toList();
  }

   addUserFilm({required UserMovies movie,}) async {
    await _firebaseFirestore.collection('films').doc(movie.id.toString()).set(
          movie.toJson(),
          SetOptions(merge: true),
        );
  }

   deleteUserFilm({required String filmId}) async {
    await _firebaseFirestore.collection('films').doc(filmId).delete();
  }
}
