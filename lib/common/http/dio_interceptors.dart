import 'package:common_utils/common/service/config_service.dart';
import 'package:common_utils/common/utils/logger.dart';
import 'package:common_utils/common/utils/toast.dart';
import 'package:dio/dio.dart';

import 'http.dart';

class DioInterceptors extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    // 对非open的接口的请求参数全部增加userId
    // if (!options.path.contains("open")) {
    //   options.queryParameters["userId"] = "xxx";
    // }

    // 头部添加token
    final String? token = ConfigService.to.getToken();
    if(token != null && token.isNotEmpty) {
      LogUtils.GGQ('-----DioInterceptors--TOKEN---->>${token}');
      options.headers["token"] = token;
    }


    LogUtils.GGQ('path->${options.path}');
    LogUtils.GGQ('uri->${options.uri}');
    // 更多业务需求
    handler.next(options);

    // super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    LogUtils.GGQ('response->${response.toString()}');
    // 请求成功是对数据做基本处理
    if (response.statusCode == 200) {
      // response.data = DioResponse(errorCode: DioResponseCode.SUCCESS, errorMsg: "操作成功~!", data: response.data);
      final body = response.data;
      if(body == null) {
        response.data = DioResponse(code: DioResponseCode.ERROR, message: "操作失败~!");
      } else {
        final code = body['code'];
        final msg = body['message'];
        final data = body['data'];
        response.data = DioResponse(code: code, message: msg,data: data);

        // if(response.requestOptions.path.contains('/login/cellphone')) {
        //   final code = body['code'];
        //   final msg = body['msg'];
        //
        //   if(code == 200) {
        //     final account = body['account'];
        //     final profile = body['profile'];
        //     final token = body['token'];
        //
        //     final data = {
        //       'userId': profile['userId'],
        //       'nickname': profile['nickname'],
        //       'token': token,
        //       'avatar': profile['avatarUrl'],
        //       'username': account['userName']
        //     };
        //     response.data = DioResponse(code: code, msg: msg,data: data);
        //   } else {
        //     response.data = DioResponse(code: code, msg: msg,data: null);
        //   }
        //
        // } else if(response.requestOptions.path.contains('/top/artists')){
        //   final code = body['code'];
        //   final msg = body['msg'];
        //
        //   if(code == 200) {
        //     final more = body['more'];
        //     final List<dynamic> artists = body['artists'];
        //     final data = {
        //       'more': more,
        //       'artists': artists,
        //     };
        //     response.data = DioResponse(code: code, msg: msg,data: data);
        //   } else {
        //     response.data = DioResponse(code: code, msg: msg,data: null);
        //   }
        // } else {
        //   final code = body['code'];
        //   final msg = body['msg'];
        //   final data = body['data'];
        //   response.data = DioResponse(code: code, msg: msg,data: data);
        // }
      }
    } else {
      response.data = DioResponse(code: DioResponseCode.ERROR, message: "操作失败~!");
    }

    // 对某些单独的url返回数据做特殊处理
    if (response.requestOptions.baseUrl.contains("???????")) {

    }

    // 根据公司的业务需求进行定制化处理

    // 重点
    LogUtils.GGQ('===============>>>>${response.toString()}');
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    ToastUtils.showToast(err.message);
    switch(err.type) {
    // 连接服务器超时
      case DioErrorType.connectTimeout:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
          LogUtils.GGQ('http error===connectTimeout:>${err.message}');
        }
        break;
    // 响应超时
      case DioErrorType.receiveTimeout:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
          LogUtils.GGQ('http error===receiveTimeout:>${err.message}');
        }
        break;
    // 发送超时
      case DioErrorType.sendTimeout:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
          LogUtils.GGQ('http error===sendTimeout:>${err.message}');
        }
        break;
    // 请求取消
      case DioErrorType.cancel:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
          LogUtils.GGQ('http error===cancel:>${err.message}');

        }
        break;
    // 404/503错误
      case DioErrorType.response:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
          LogUtils.GGQ('http error===response:>${err.message}');

        }
        break;
    // other 其他错误类型
      case DioErrorType.other:
        {
          LogUtils.GGQ('http error===other:>${err.message}');
        }
        break;

    }
    super.onError(err, handler);
  }
}
