import 'package:epcqrgenerator/screens/codes_screen.dart';
import 'package:epcqrgenerator/screens/home_screen.dart';
import 'package:epcqrgenerator/screens/settings_screen.dart';

class MyAppRouter {

  static const HOME = '/';
  static const SETTINGS = 'settings';
  static const CODES = 'codes';

  static routes() {
    return {
      SETTINGS: (context) => SettingsScreen(),
      CODES: (context) => CodesScreen(),
    };
  }
}