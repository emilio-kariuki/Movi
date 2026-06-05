import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';

class RegisterViewModel extends ReactiveViewModel {
  final _auth = locator<AuthService>();
  final _navigation = locator<NavigationService>();
  final _snackbar = locator<SnackbarService>();
  final nameController = TextEditingController();
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

  Future<void> register({
    String? name,
    String? email,
    String? password,
  }) async {
    final safeName = (name ?? nameController.text).trim();
    final safeEmail = (email ?? emailController.text).trim();
    final safePassword = (password ?? passwordController.text).trim();

    if (safeName.isEmpty || safeEmail.isEmpty || safePassword.isEmpty) {
      _snackbar.showSnackbar(message: 'Please fill in all fields');
      return;
    }
    setBusy(true);
    try {
      final success = await _auth.register(
        name: safeName,
        email: safeEmail,
        password: safePassword,
      );
      if (success) {
        await _navigation.replaceWithHomeView();
      } else {
        _snackbar.showSnackbar(message: 'Registration failed');
      }
    } catch (_) {
      _snackbar.showSnackbar(message: 'Registration failed');
    } finally {
      setBusy(false);
    }
  }

  void navigateToLogin() => _navigation.navigateToLoginView();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
