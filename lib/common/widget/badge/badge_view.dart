import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class BadgeView extends StatelessWidget {

  BadgeView({Key? key, required this.controller,required this.child,this.badgePosition,this.badgeTextStyle,this.isDot}) : super(key: key);

  final BadgeController controller;
  final Widget child;
  final BadgePosition? badgePosition;
  final TextStyle? badgeTextStyle;
  final bool? isDot;



  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ValueListenableBuilder<String>(
        valueListenable: controller,
        builder: (context, value, _) => Badge(
          animationType: BadgeAnimationType.scale,
          padding: ifDot()? EdgeInsets.zero: const EdgeInsets.all(4.0),
          elevation: 2.0,
          showBadge: controller.value.isNotEmpty,
          position: ifDot()? badgePosition?? BadgePosition.topEnd(top: -2.0,end: -6.0) : badgePosition,
          borderSide: ifDot()? BorderSide.none : const BorderSide(color: Colors.white,width: 0.6),
          badgeContent: ifDot()? const SizedBox(width: 10.0,height: 10.0,) : Text(controller.value, style: badgeTextStyle?? const TextStyle(fontSize: 8.0, color: Colors.white)),
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
