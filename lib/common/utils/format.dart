class FormatUtils {
  // 格式化手机号
  static String formatPhone(String? phone) {
    if (phone == null) {
      return '';
    }
    if (phone.length != 11) {
      return phone;
    }
    String a = phone.substring(0, 3);
    String b = phone.substring(3, 7);
    String c = phone.substring(7, 11);
    return '$a $b $c';
  }
}
