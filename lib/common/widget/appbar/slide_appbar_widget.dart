import 'package:common_utils/common/base/base.dart';

class SlideAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const SlideAppBarWidget({Key? key,required this.visible,required this.controller,required this.child}) : super(key: key);

  final bool visible;
  final AnimationController controller;
  final PreferredSizeWidget child;


  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, -1),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn,
      )),
      child: child,
    );
  }

  @override
  Size get preferredSize => child.preferredSize;
}
