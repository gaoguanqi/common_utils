import 'dart:convert' as convert;

import 'package:common_utils/common/config/config.dart';
import 'package:common_utils/common/http/http.dart';

class DioResponse {

  DioResponse({
    this.code,
    this.msg,
    this.data,
  });

  /// 自定义code(可根据内部定义方式)
  int? code = -1;
  /// 消息(例如成功消息文字/错误消息文字)
  String? msg = '未知错误！';
  /// 接口返回的数据
  dynamic? data;


  DioResponse.formError(dynamic error) {
    NetError err = ErrorHandle.handleException(error);
    DioResponse(code: err.code,msg: err.msg);
  }


  DioResponse.fromJson(Map<String, dynamic> json) {
    code = json[DataKey.code] as int?;
    if(json.containsKey(DataKey.msg)) {
      msg = json[DataKey.msg] as String?;
    }
    if (json.containsKey(DataKey.data)) {
      data = json[DataKey.data];
    }
  }



}

Map<String, dynamic> parseData(String data) {
  return convert.json.decode(data) as Map<String, dynamic>;
}