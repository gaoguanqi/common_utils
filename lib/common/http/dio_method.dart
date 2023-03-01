enum DioMethod {
  get,
  post,
  put,
  patch,
  delete,
  head,
}
/// 使用拓展枚举替代 switch判断取值
/// https://zhuanlan.zhihu.com/p/98545689
extension MethodExtension on DioMethod {
  String get value => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'][index];
}