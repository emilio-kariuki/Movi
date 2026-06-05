import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:stacked/stacked.dart';
import '../app/app.locator.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';
import 'preferences_service.dart';

class AuthService with ReactiveServiceMixin {
  final _prefs = locator<PreferencesService>();
  final _firebaseService = locator<FirebaseService>();

  bool _isLoggedIn = false;
  String? _currentUserId;

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserId => _currentUserId;

  StreamSubscription<fb.User?>? _authSubscription;

  void init() {
    _authSubscription =
        fb.FirebaseAuth.instance.authStateChanges().listen((user) {
      _isLoggedIn = user != null;
      _currentUserId = user?.uid;
      notifyListeners();
    });
  }

  void dispose() {
    _authSubscription?.cancel();
  }

  Future<bool> login({required String email, required String password}) async {
    final credential = await fb.FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    final user = credential.user;
    if (user == null) return false;

    await _prefs.setLoginStatus(status: true);
    await _prefs.setUserId(userId: user.uid);
    await _prefs.setEmail(email: email);
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await fb.FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final user = credential.user;
    if (user == null) return false;

    await _prefs.setLoginStatus(status: true);
    await _prefs.setUserId(userId: user.uid);
    await _prefs.setEmail(email: email);
    await _firebaseService.createUser(
      user: User(email: email, id: user.uid, name: name, interest: 'movies'),
    );
    return true;
  }

  Future<void> logout() async {
    await fb.FirebaseAuth.instance.signOut();
    await _prefs.setLoginStatus(status: false);
  }

  Future<void> deleteAccount() async {
    await fb.FirebaseAuth.instance.currentUser?.delete();
  }
}
