import 'package:common_utils/common/http/http.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class TokenInterceptor extends QueuedInterceptor {

  Dio? _tokenDio;

  Future<String?> refreshToken() async {
    String token = ConfigService.to.getToken()?? '';
    final Map<String, String> params = <String, String>{};
    params['token'] = token;
    try {
      _tokenDio ??= Dio();
      _tokenDio!.options = DioUtil().dio.options;

      final Response<dynamic> response = await _tokenDio!.post<dynamic>('/refreshToken',data: params);
      if(response.statusCode == ErrorHandle.success) {
        Map map = parseData(response.data.toString());
        String? token = map['token'];
        ConfigService.to.saveToken(token);
        return token;
      }
    } catch(e) {
      LogUtils.GGQ('刷新Token失败！');
    }
    return null;
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == ErrorHandle.unauthorized) {
      LogUtils.GGQ('-----------自动刷新Token------------');
      final String? accessToken = await refreshToken(); // 获取新的accessToken
      LogUtils.GGQ('-----------NewToken: $accessToken ------------');
      if (accessToken != null && accessToken.isNotEmpty) {
        ConfigService.to.saveToken(accessToken);
        // 重新请求失败接口
        final RequestOptions request = response.requestOptions;
        request.headers[DataKey.auth] = accessToken;

        final Options options = Options(
          headers: request.headers,
          method: request.method,
        );

        try {
          LogUtils.GGQ('----------- 重新请求接口 ------------');
          final Response<dynamic> response = await _tokenDio!.request<dynamic>(request.path,
            data: request.data,
            queryParameters: request.queryParameters,
            cancelToken: request.cancelToken,
            options: options,
            onReceiveProgress: request.onReceiveProgress,
          );
          return handler.next(response);
        } on DioError catch (e) {
          return handler.reject(e);
        }
      }
    }
    super.onResponse(response, handler);
  }
}
