import 'dart:io';
import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/db/db.dart';
import 'package:common_utils/common/service/service.dart';
import 'package:common_utils/common/utils/utils.dart';
import 'package:flutter/services.dart';


///全局初始化
class Global{

  /// 是否 release
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");
  /// 是否 ios
  static bool isIOS = Platform.isIOS;
  /// 是否 android
  static bool isAndroid = Platform.isAndroid;

  static DBUtil? dbUtil;

  static Future<void> init() async {
     // 运行初始
     WidgetsFlutterBinding.ensureInitialized();
      // 屏幕方向  竖屏
     await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

     setSystemUi();
     Loading();
     await StorageUtil().init();
     await DBUtil.install();
     dbUtil = await DBUtil.getInstance();
     // 业务服务
     Get.put<ConfigService>(ConfigService());

  }


  static void setSystemUi() {
    if (GetPlatform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarDividerColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }

}