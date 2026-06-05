import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';

class LoginViewModel extends ReactiveViewModel {
  final _auth = locator<AuthService>();
  final _navigation = locator<NavigationService>();
  final _snackbar = locator<SnackbarService>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_auth];

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    rebuildUi();
  }

  Future<void> login({String? email, String? password}) async {
    final safeEmail = (email ?? emailController.text).trim();
    final safePassword = (password ?? passwordController.text).trim();

    if (safeEmail.isEmpty || safePassword.isEmpty) {
      _snackbar.showSnackbar(message: 'Please fill in all fields');
      return;
    }
    setBusy(true);
    try {
      final success = await _auth.login(
        email: safeEmail,
        password: safePassword,
      );
      if (success) {
        await _navigation.replaceWithHomeView();
      } else {
        _snackbar.showSnackbar(message: 'Login failed');
      }
    } catch (_) {
      _snackbar.showSnackbar(message: 'Login failed');
    } finally {
      setBusy(false);
    }
  }

  void navigateToRegister() => _navigation.navigateToRegisterView();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
