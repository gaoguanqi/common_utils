import 'package:intl/intl.dart';


class DateUtil {

  static String format = 'yyyy-MM-dd HH:mm:ss';
  // 格式化日期到字符串 默认 yyyy-MM-dd
  static formatDate({String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(DateTime.now());
  }

  /// 格式化时间
  static String doTimeLineFormat(DateTime dt) {
    var now = DateTime.now();
    var difference = now.difference(dt);

    // 1天内
    if (difference.inHours < 24) {
      return "${difference.inHours} 小时";
    }
    // 30天内
    else if (difference.inDays < 30) {
      return "${difference.inDays} 天";
    }
    // MM-dd
    else if (difference.inDays < 365) {
      final dtFormat = DateFormat('MM-dd');
      return dtFormat.format(dt);
    }
    // yyyy-MM-dd
    else {
      final dtFormat = DateFormat('yyyy-MM-dd');
      var str = dtFormat.format(dt);
      return str;
    }
  }

}