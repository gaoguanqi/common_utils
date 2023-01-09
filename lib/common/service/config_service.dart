
import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/config/config.dart';
import 'package:common_utils/common/utils/utils.dart';

class ConfigService extends GetxService{

  static ConfigService get to => Get.find<ConfigService>();


  bool _isFirst = false;

  String? _token;

  ThemeMode _themeMode = ThemeMode.system;


  Locale locale = const Locale('zh', 'CN');

  List<Locale> languages = [
    const Locale('zh', 'CN'),
    const Locale('en', 'US'),
  ];




  @override
  void onInit() async{
    _isFirst = StorageUtil().getBool(SaveInfoKey.FIRST_OPEN)?? false;
    _token = StorageUtil().getJSON(SaveInfoKey.TOKEN);
    _themeMode = StorageUtil().getBool(SaveInfoKey.THEME_MODEL)?? false ? ThemeMode.dark: ThemeMode.light;
    Get.locale = locale;
    super.onInit();
  }


  @override
  void onClose() {
    super.onClose();
  }


  String? getToken() {
    if(_token != null && _token!.isNotEmpty) {
      return _token;
    }
    _token = StorageUtil().getJSON(SaveInfoKey.TOKEN);
    return _token;
  }

  void saveToken(String? token) {
    if(token != null && token.isNotEmpty) {
      StorageUtil().setJSON(SaveInfoKey.TOKEN, token).then((value) {
        if(value) {
          _token = token;
        }
      });
    }
  }

  bool isFirst() => _isFirst;

  void saveFirst() {
    StorageUtil().setBool(SaveInfoKey.FIRST_OPEN, true);
    _isFirst = true;
  }


  ThemeMode getThemeMode() {
    return _themeMode;
  }

  void switchThemeModel() {
    bool isDarkMode = StorageUtil().getBool(SaveInfoKey.THEME_MODEL)?? false;
    StorageUtil().setBool(SaveInfoKey.THEME_MODEL, !isDarkMode).then((value) {
      if(value) {
        _themeMode = StorageUtil().getBool(SaveInfoKey.THEME_MODEL)?? false ? ThemeMode.dark: ThemeMode.light;
        Get.changeThemeMode(_themeMode);
      }
    });
  }

  void changeEn() {
    locale = languages[1];
    Get.updateLocale(locale);
  }

  void changeZh() {
    locale = languages[0];
    Get.updateLocale(locale);
  }
}