import 'package:common_utils/common/config/config.dart';
import 'package:common_utils/common/service/service.dart';
import 'package:common_utils/common/utils/utils.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String? accessToken = ConfigService.to.getToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers[DataKey.auth] = accessToken;
    }
    if (!DeviceUtil.isWeb) {
      // https://developer.github.com/v3/#user-agent-required
      options.headers['User-Agent'] = 'Mozilla/5.0';
    }
    super.onRequest(options, handler);
  }
}