import 'dart:async';
import 'dart:io';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'http.dart';

class DioUtil {

  /// 连接超时时间
  static const Duration _connectTimeout = Duration(seconds: 15);
  /// 响应超时时间
  static const Duration _receiveTimeout = Duration(seconds: 15);

  static const Duration _sendTimeout = Duration(seconds: 15);


  static DioUtil? _instance;
  static Dio _dio = Dio();
  Dio get dio => _dio;

  DioUtil._internal() {
    _instance = this;
    _instance!._init();
  }

  factory DioUtil() => _instance ?? DioUtil._internal();

  static DioUtil? getInstance() {
    _instance ?? DioUtil._internal();
    return _instance;
  }


  /// 取消请求token
  final CancelToken _cancelToken = CancelToken();

  _init() {
    /// 初始化基本选项
    BaseOptions options = BaseOptions(
        baseUrl: GlobalConfig.BASE_URL,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout
    );

    /// 初始化dio
    _dio = Dio(options);

    /// 添加转换器
    _dio.transformer = DioTransformer();

    /// 添加cookie管理器
    // _dio.interceptors.add(CookieManager(cookieJar));

    /// 刷新token拦截器(lock/unlock)
    if(ConfigService.to.isRefreshToken) {
      _dio.interceptors.add(TokenInterceptor());
    }

    /// 添加缓存拦截器
    // _dio.interceptors.add(DioCacheInterceptors());

    /// 添加拦截器
    _dio.interceptors.add(AdapterInterceptor());

    /// 添加日志拦截器
    _dio.interceptors.add(LoggingInterceptor());
  }

  /// 设置Http代理(设置即开启)
  void setProxy({
    String? proxyAddress,
    bool enable = false
  }) {
    if (enable) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.findProxy = (uri) {
          return proxyAddress ?? '';
        };
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  /// 设置https证书校验
  void setHttpsCertificateVerification({
    String? pem,
    bool enable = false
  }) {
    if (enable) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate  = (client) {
        client.badCertificateCallback=(X509Certificate cert, String host, int port){
          if(cert.pem == pem){ // 验证证书
            return true;
          }
          return false;
        };
      };
    }
  }

  /// 开启日志打印
  void openLog() {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Options _checkOptions(DioMethod method, Options? options) {
    options ??= Options();
    options.method = method.value;
    return options;
  }

  /// 请求类
  Future<DioResponse> _request<T>(String path, {
    DioMethod method = DioMethod.get,
    Map<String, dynamic>? params,
    data,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    options ??= _checkOptions(method, options);
    final Response<T> response = await _dio.request<T>(
        path,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken ?? _cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress
    );
    try {
      final String data = response.data.toString();
      LogUtils.GGQ("===datane呢====================>>>>>${data}");
      return DioResponse.fromJson(parseData(data));
    } catch (e) {
      return DioResponse.formError(ErrorHandle.parseError);
    }
  }

  Future<dynamic> request<T>(String path,  {
    DioMethod method = DioMethod.get,
    Map<String, dynamic>? params,
    data,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool? isShowLoading,
    bool? isShowToast,
    Success? success,
    Fail? fail,
  }) {
    if(isShowLoading?? false) {
      Loading.show();
    }
    return _request<T>(path,
      method: method,
      params: params,
      data: data,
      cancelToken: cancelToken,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress
    ).then<void>((DioResponse result) {
      if (ResponseUtils.isSuccess(result.code)) {
         success?.call(result.data);
      } else {
        if(isShowToast?? false) {
          ToastUtils.showToast(ResponseUtils.getMessage(result.msg));
        }
        fail?.call(result.code?? ErrorHandle.unknownError, ResponseUtils.getMessage(result.msg));
      }
    }, onError: (dynamic e) {
      LogUtils.GGQ('-----onError----->>${e.toString()}');
      final NetError error = ErrorHandle.handleException(e);
      if(isShowToast?? false) {
        ToastUtils.showToast(error.msg);
      }
      fail?.call(error.code,error.msg);
    }).whenComplete(() => {
      if(isShowLoading?? false) {
        Loading.dismiss()
      }
    });
  }


  /// 取消网络请求
  void cancelRequests({CancelToken? token}) {
    token ?? _cancelToken.cancel('cancelled');
  }
}


typedef Success = void Function(dynamic data);
typedef Fail = void Function(int code,String msg);
