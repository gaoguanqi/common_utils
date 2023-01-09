import 'dart:ui';

//延时执行
class DelayedUtils{

  static delayed(VoidCallback voidCallback,{int milliseconds = 2000}) async {
    // 延时milliseconds执行返回
    await Future.delayed(Duration(milliseconds: milliseconds),voidCallback);
  }
//  使用: DelayedUtils.delayed(3000, () { });
}