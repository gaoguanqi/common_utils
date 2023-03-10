class GlobalConfig{
  static const String BASE_URL = 'http://192.168.50.200:8080';

  /// 拍摄视频最大时长 30 秒
  static const Duration takeVideoDuration = Duration(seconds: 30);

}

class SaveInfoKey {
  static const String FIRST_OPEN = 'FIRST_OPEN';

  static const String LANGUAGE_CODE = 'LANGUAGE_CODE';

  static const String TOKEN = 'TOKEN';
  static const String THEME_MODEL = 'THEME_MODEL';

  static const String USER_INFO = 'USER_INFO';
}

class BundleKey {

  static const String ID = 'ID';

}


class EventCode {
  static const int EVENT_LOGIN = 999;
  static const int EVENT_NETWORK = 100;
}


class IDKey {
  static const String pageState = 'pageState';
  static const String refresh = 'refresh';
}


class DataKey {
  static const String code = 'code';
  static const String msg = 'msg';
  static const String data = 'data';

  static const String auth = 'Authorization';
}
