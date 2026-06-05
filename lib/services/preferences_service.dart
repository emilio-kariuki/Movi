import 'package:shared_preferences/shared_preferences.dart';

const String _isLoggedIn = 'IS_LOGGED_IN';
const String _userId = 'USER_ID';
const String _email = 'EMAIL';

class PreferencesService {
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedIn) ?? false;
  }

  Future<void> setLoginStatus({required bool status}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedIn, status);
  }

  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userId) ?? '';
  }

  Future<void> setUserId({required String userId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userId, userId);
  }

  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_email) ?? '';
  }

  Future<void> setEmail({required String email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_email, email);
  }
}
