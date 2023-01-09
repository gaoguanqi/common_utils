class RegexUtils {
  ///校验手机号
  static isPhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    // 手机号正则
    String regex = '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$';
    return RegExp(regex).hasMatch(phone);
  }

  /// 检查邮箱格式
  bool isEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    // 邮箱正则
    String regex = '^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$';
    return RegExp(regex).hasMatch(email);
  }

  /// 检查字符长度
  bool isStringLength(String? input, int length) {
    if (input == null || input.isEmpty) return false;
    return input.length >= length;
  }
}
