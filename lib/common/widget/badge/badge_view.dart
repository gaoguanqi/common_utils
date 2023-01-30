import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

class BadgeView extends StatelessWidget {

  BadgeView({Key? key, required this.controller,required this.child,this.badgePosition,this.badgeTextStyle,this.isDot}) : super(key: key);

  final BadgeController controller;
  final Widget child;
  final badges.BadgePosition? badgePosition;
  final TextStyle? badgeTextStyle;
  final bool? isDot;



  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ValueListenableBuilder<String>(
        valueListenable: controller,
        builder: (context, value, _) => badges.Badge(
          // animationType: badges.BadgeAnimationType.scale,
          // padding: ifDot()? EdgeInsets.zero: const EdgeInsets.all(4.0),
          // elevation: 2.0,
          // showBadge: controller.value.isNotEmpty,
          // position: ifDot()? badgePosition?? badges.BadgePosition.topEnd(top: -2.0,end: -6.0) : badgePosition,
          // borderSide: ifDot()? BorderSide.none : const BorderSide(color: Colors.white,width: 0.6),
          // badgeContent: ifDot()? const SizedBox(width: 10.0,height: 10.0,) : Text(controller.value, style: badgeTextStyle?? const TextStyle(fontSize: 8.0, color: Colors.white)),

          position: badges.BadgePosition.topEnd(top: -10, end: -12),
          showBadge: true,
          ignorePointer: false,
          onTap: () {},
          badgeContent: ifDot()? const SizedBox(width: 10.0,height: 10.0,) : Text(controller.value, style: badgeTextStyle?? const TextStyle(fontSize: 8.0, color: Colors.white)),
          badgeAnimation: const badges.BadgeAnimation.rotation(
            animationDuration: Duration(seconds: 1),
            colorChangeAnimationDuration: Duration(seconds: 1),
            loopAnimation: false,
            curve: Curves.fastOutSlowIn,
            colorChangeAnimationCurve: Curves.easeInCubic,
          ),
          badgeStyle: badges.BadgeStyle(
            shape: badges.BadgeShape.square,
            badgeColor: Colors.blue,
            padding: const EdgeInsets.all(5.0),
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
            borderGradient: const badges.BadgeGradient.linear(
                colors: [Colors.red, Colors.black]),
            badgeGradient: const badges.BadgeGradient.linear(
              colors: [Colors.blue, Colors.yellow],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            elevation: 2.0,
          ),
          child: child,
        ),
      ),
    );
  }

  bool ifDot() {
    if(isDot != null && isDot!) {
      return true;
    }
    return false;
  }
}

class BadgeController extends ValueNotifier<String> {
  BadgeController(super.value);


  void setBadge(String? number) {
    if(number != null && number.isNotEmpty) {
      int? n = int.tryParse(number);
      if(n == null || n <= 0) {
        value = '';
      } else if(n > 99) {
        value = '99';
      } else {
        value = number;
      }
    }
  }

  void setDot() {
    value = '1';
  }

  void clear() {
    value = '';
  }

}
