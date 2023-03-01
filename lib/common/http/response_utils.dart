
import 'package:common_utils/common/http/http.dart';

class ResponseUtils {

  static bool isSuccess(int? code){
    if(code == null) return false;
    return code == ErrorHandle.success;
  }

  static String getMessage(String? msg){
    if(msg == null) {
      return '操作失败!!!';
    }
    return msg;
  }
}