import 'dart:async';
import 'package:dio/dio.dart';

class DioTransformer extends BackgroundTransformer {

  @override
  Future<String> transformRequest(RequestOptions options) {
    // 可添加全局参数
    // options.headers
    // options.queryParameters
    return super.transformRequest(options);
  }

  @override
  Future transformResponse(RequestOptions options, ResponseBody response) async {
    // 例如我们响应选项里面没有自定义某些头部数据,那我们就可以自行添加
    // options.extra['myHeader'] = 'abc';
    return super.transformResponse(options, response);
  }

}