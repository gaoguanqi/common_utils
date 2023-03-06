import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/res/res.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BottomSheetPicker {

  static Future<T?> showModalSheet<T>(
      {required BuildContext context, Widget? child, Color? backgroundColor,Color? barrierColor}) {
    return showMaterialModalBottomSheet<T>(
        context: context,
        backgroundColor: backgroundColor,
        barrierColor: barrierColor,
        // 创建圆角矩形边框。
        shape: const RoundedRectangleBorder(
          // 每个角度数
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(KDimens.modalRadius),
            topRight: Radius.circular(KDimens.modalRadius),
          ),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            child: child,
          );
        });
  }
}