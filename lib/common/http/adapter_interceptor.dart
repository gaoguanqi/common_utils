import 'package:dio/dio.dart';

import 'http.dart';

class AdapterInterceptor extends Interceptor {


  static const String _kDefaultText = '无返回信息';

  static const String _kSuccessFormat = '{"code":200,"msg":"%s"}';
  static const String _kFailureFormat = '{"code":%d,"msg":"%s"}';


  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final Response<dynamic> r = adapterData(response);
    super.onResponse(r, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      adapterData(err.response!);
    }
    super.onError(err, handler);
  }


  Response<dynamic> adapterData(Response<dynamic> response) {
    String result;
    String content = response.data?.toString() ?? '';
    /// 成功时，直接格式化返回
    if (response.statusCode == ErrorHandle.success) {
      if (content.isEmpty) {
        content = _kDefaultText;
        result = sprintf(_kSuccessFormat, [content]);
      } else {
        result = content;
      }
    } else {
      if(content.isEmpty) {
        content = _kDefaultText;
        result = sprintf(_kFailureFormat, [-1,content]);
      } else {
        result = content;
      }
      NetError error = ErrorHandle.handleException(response.statusCode);
      result = sprintf(_kFailureFormat, [error.code,error.msg]);
    }
    response.data = result;
    return response;
  }
}