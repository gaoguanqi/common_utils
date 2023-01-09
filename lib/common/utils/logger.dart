class LogUtils {
  static void GGQ (dynamic msg,{String? tag = 'GGQ'}) {
    if(msg != null) {
      StringBuffer sb = StringBuffer();
      sb.write('$tag--->');
      sb.write(msg);
      print(sb.toString());
    }
  }

  static void write(String text, {bool isError = false}) {
    Future.microtask(() => print('** $text. isError: [$isError]'));
  }
}