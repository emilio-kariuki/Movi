import 'package:movi/Util/GlobalConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_LOGGED_IN) ?? false;
  }

  Future setLoginStatus({required bool status}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(IS_LOGGED_IN, status);
  }

  Future<bool> isWelcomePageSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_WELCOME_PAGE_SEEN) ?? false;
  }

  Future setWelcomePageSeen({required bool status}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(IS_WELCOME_PAGE_SEEN, status);
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERD_ID) ?? "";
  }

  Future setUserID({required String userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(USERD_ID, userId);
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(EMAIL) ?? "";
  }

  Future setEmail({required String email}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(EMAIL, email);
  }
}
