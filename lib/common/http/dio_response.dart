
import 'dart:collection';
import 'dart:convert' as convert;

import 'package:common_utils/common/utils/logger.dart';


class DioResponse<Object> {


  /// 自定义code(可根据内部定义方式)
  final int? code;
  /// 消息(例如成功消息文字/错误消息文字)
  final String? message;
  /// 接口返回的数据
  final Object? data;
  /// 需要添加更多
  /// .........
  DioResponse({
    this.code,
    this.message,
    this.data,
  });

  static DioResponse getResponse(String data) {
    LogUtils.GGQ('--DioResponse-->>>>${data}');
    final Map<String, dynamic> map = convert.jsonDecode(data);
    return DioResponse(code: map['code'],message: map['message'],data: map['data']);
  }

  static DioResponse defaultResponse() {
    final Map<String, dynamic> map = HashMap();
    map['code'] = -1;
    map['message'] = '操作失败，请稍候重试！';
    return getResponse(convert.jsonDecode(map.toString()));
  }
  @override
  String toString() {
    StringBuffer sb = StringBuffer('{');
    sb.write("\"message\":\"$message\"");
    sb.write(",\"code\":\"$code\"");
    sb.write(",\"data\":\"${data.toString()}\"");
    sb.write('}');
    return sb.toString();
  }
}

class DioResponseCode {
  /// 成功
  static const int SUCCESS = 200;
  /// 错误
  static const int ERROR = -1;
/// 更多
}