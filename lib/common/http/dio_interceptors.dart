import 'package:common_utils/common/service/config_service.dart';
import 'package:common_utils/common/utils/logger.dart';
import 'package:common_utils/common/utils/toast.dart';
import 'package:common_utils/common/utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'http.dart';

class DioInterceptors extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    final connectivityResult  = await ConfigService.to.connectivity.checkConnectivity();
    LogUtils.GGQ('----connectivityResult------>>${connectivityResult.toString()}');

    if(ConnectivityResult.none.name == connectivityResult.name) {
      ToastUtils.showToast('请检查网络！');
      Loading.dismiss();
      return;
    }

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
    // error统一处理
    ApiException apiException = ApiException.init(err);
    // err.error = apiException;
    err.copyWith(response: Response(requestOptions: err.requestOptions,statusCode: apiException.code,statusMessage: apiException.message));
    handler.next(err);
  }
}
