import 'package:common_utils/common/db/db.dart';
import 'package:common_utils/common/utils/logger.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';


class DBUtil{
  /// 实例
  static DBUtil? _instance;

  /// 用户信息
  late Box userBox;

  /// 初始化，需要在 main.dart 调用
  /// <https://docs.hivedb.dev/>
  static Future<void> install() async {
    /// 初始化数据库地址
    Directory document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);
    /// 注册自定义对象（实体）
    /// <https://docs.hivedb.dev/#/custom-objects/type_adapters>
    /// Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(UserAdapter());
  }

  /// 初始化 Box
  static Future<DBUtil?> getInstance() async {
    if (_instance == null) {
      _instance = DBUtil();
      // await Hive.initFlutter();
      _instance?.userBox = await Hive.openBox('user');
    }
    return _instance;
  }

  //---------用户信息----------------
  Future<bool> saveUser(User user) async{
    LogUtils.GGQ('------saveUser------>>>${user.toString()}');
    int? result = await _instance?.userBox.add(user);
    if(result != null && result >= 0) {
      return true;
    }
    return false;
  }

  Future<User?> getUser() async{
    final users = _instance?.userBox.values;
    if(users != null && users.isNotEmpty){
      return users.last;
    }
    return null;
  }

  Future<bool> clearUser() async{
    int? result = await _instance?.userBox.clear();
    LogUtils.GGQ('---clearUser-->${result}');
    if(result != null && result >= 0) {
      return true;
    }
    return false;
  }

}