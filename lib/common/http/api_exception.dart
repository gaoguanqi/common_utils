import 'package:dio/dio.dart';

/// 自定义异常
class ApiException implements Exception {
  final String? message;
  final int? code;

  ApiException({this.code, this.message});


  factory ApiException.init(DioError error) {
    switch (error.type) {
      case DioErrorType.connectionError:
        return ApiException(message: '连接服务器出错！');
      case DioErrorType.connectionTimeout:
        return ApiException(message: '连接服务器超时！');
      case DioErrorType.sendTimeout:
        return ApiException(message: '发送超时！');
      case DioErrorType.receiveTimeout:
        return ApiException(message: '响应超时！');
      case DioErrorType.badResponse:
        return ApiException(message: '操作失败，请联系管理员！');
      case DioErrorType.badCertificate:
        return ApiException(message: '证书出错！');
      case DioErrorType.cancel:
        return ApiException(message: '请求取消！');
      case DioErrorType.unknown:
        try {
          int errCode = error.response?.statusCode ?? -1;
          switch (errCode) {
            case 400:
              return ApiException(code: errCode, message: '请求语法错误！');
            case 401:
              return ApiException(code: errCode, message: '没有权限！');
            case 403:
              return ApiException(code: errCode, message: '服务器拒绝执行！');
            case 404:
              return ApiException(code: errCode, message: '无法连接服务器！');
            case 405:
              return ApiException(code: errCode, message: '请求方法被禁止！');
            case 500:
              return ApiException(code: errCode, message: '服务器内部错误！');
            case 502:
              return ApiException(code: errCode, message: '无效的请求！');
            case 503:
              return ApiException(code: errCode, message: '服务器挂了！');
            case 505:
              return ApiException(code: errCode, message: '不支持HTTP协议请求！');
            default:
              return ApiException(
                  code: errCode, message:error.response?.statusMessage ?? '未知错误！');
          }
        } catch (e) {
          return ApiException(message: '未知错误：${e.toString()}');
        }
      default:
        return ApiException(message: error.message);
    }
  }
}