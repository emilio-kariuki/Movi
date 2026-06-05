import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/preferences_service.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _preferences = locator<PreferencesService>();
  final _navigation = locator<NavigationService>();

  Future<void> runStartupLogic() async {
    final loggedIn = await _preferences.isLoggedIn();
    if (loggedIn) {
      await _navigation.replaceWithHomeView();
    } else {
      await _navigation.replaceWithLoginView();
    }
  }
}
