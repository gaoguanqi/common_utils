import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/*
  ScreenUtil.pixelRatio       //设备的像素密度
    ScreenUtil.screenWidth      //设备宽度
    ScreenUtil.screenHeight     //设备高度
    ScreenUtil.bottomBarHeight  //底部安全区距离，适用于全面屏下面有按键的
    ScreenUtil.statusBarHeight  //状态栏高度 刘海屏会更高  单位px
    ScreenUtil.textScaleFactor //系统字体缩放比例

    ScreenUtil().scaleWidth  // 实际宽度的dp与设计稿px的比例
    ScreenUtil().scaleHeight // 实际高度的dp与设计稿px的比例
*/

Size designSize() {
  return const Size(375, 812 - 44 - 34);
  // return Size(1080, 1920);
}

/// 获取屏幕宽度
double getScreenWidth() {
  return ScreenUtil().screenWidth;
}
/// 获取宽度百分比
double getScaleWidth(double scale) {
  return ScreenUtil().screenWidth * scale;
}
/// 获取宽度
double getWidth(double width) {
  return ScreenUtil().setWidth(width);
}
/// 获取屏幕高度
double getScreenHeight() {
  return ScreenUtil().screenHeight;
}
/// 获取高度百分比
double getScaleHeight(double scale) {
  return ScreenUtil().screenHeight * scale;
}
/// 获取高度
double getHeight(double height) {
  return ScreenUtil().setHeight(height);
}
///获取圆角
double getRadius(double radius) {
  return ScreenUtil().radius(radius);
}
///获取字号
double getSP(double sp) {
  return ScreenUtil().setSp(sp);
}
/// 填充屏幕
Size screenSize() {
  return Size(getScreenWidth(), getScreenHeight());
}




