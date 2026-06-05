import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class ProfileViewModel extends ReactiveViewModel {
  final _auth = locator<AuthService>();
  final _firebaseService = locator<FirebaseService>();
  final _navigation = locator<NavigationService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_auth, _firebaseService];

  User? get user => _firebaseService.currentUser;

  Future<void> loadUser() async {
    setBusy(true);
    try {
      final uid = fb.FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await _firebaseService.loadUser(id: uid);
      }
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> logout() async {
    await _auth.logout();
    await _navigation.replaceWithLoginView();
  }

  Future<void> deleteAccount() async {
    final uid = fb.FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _firebaseService.deleteUser(id: uid);
    }
    await _navigation.replaceWithLoginView();
  }

  void navigateToFavourites() => _navigation.navigateToFavouritesView();
}
