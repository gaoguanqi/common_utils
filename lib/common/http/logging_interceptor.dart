import 'package:common_utils/common/http/http.dart';
import 'package:common_utils/common/utils/utils.dart';
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor{

  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTime = DateTime.now();
    LogUtils.GGQ('----------Start----------');
    if (options.queryParameters.isEmpty) {
      LogUtils.GGQ('RequestUrl: ${options.baseUrl}${options.path}');
    } else {
      LogUtils.GGQ('RequestUrl: ${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}');
    }
    LogUtils.GGQ('RequestMethod: ${options.method}');
    LogUtils.GGQ('RequestHeaders:${options.headers}');
    LogUtils.GGQ('RequestContentType: ${options.contentType}');
    LogUtils.GGQ('RequestData: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _endTime = DateTime.now();
    final int duration = _endTime.difference(_startTime).inMilliseconds;
    // 输出结果
    LogUtils.GGQ(response.data.toString());
    LogUtils.GGQ('----------End: $duration 毫秒----------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    LogUtils.GGQ('----------Error-----------');
    super.onError(err, handler);
  }
}