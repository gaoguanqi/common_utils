import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/widget/dialog/base_dialog.dart';
import 'package:common_utils/common_utils.dart';

class PhotoDialog implements BaseDialog {
  static void show(VoidCallback onImage,VoidCallback onCamera,VoidCallback onVideo) {
    if (Get.isBottomSheetOpen == true) {
      return;
    }
    Get.bottomSheet(
      _buildDialog(onImage,onCamera,onVideo),
      elevation: 8.0,
      enterBottomSheetDuration: const Duration(milliseconds: 800),
      exitBottomSheetDuration: const Duration(milliseconds: 300),
      barrierColor: Colors.grey.shade100.withAlpha(200),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      )
    );
  }

  static Widget _buildItem(String name, IoniconsData icon,VoidCallback call) {
    return TextButton(onPressed: call, child: Row(
      children: [
        CircleAvatar(
            radius: 12.0,
            backgroundColor: Colors.black12,
            child: Icon(icon,color: Colors.black54,size: 16.0)),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
        Text(name,style: const TextStyle(fontSize: 14.0,color: Colors.black54,fontWeight: FontWeight.bold),)
      ],
    ));
  }
  static Widget _buildDialog(VoidCallback onImage,VoidCallback onCamera,VoidCallback onVideo) {

    return Container(
      padding: const EdgeInsets.only(bottom: 36.0),
      child: Wrap(
      children: [
        _buildItem('相冊',Ionicons.image,() => {
          onImage.call()
        }),
        const Divider(height: 0.5, thickness: 0.5, indent: 10.0, endIndent: 10.0,color: Colors.black12),
        _buildItem('拍照',Ionicons.camera,() => {
          onCamera.call()
        }),
        const Divider(height: 0.5, thickness: 0.5, indent: 10.0, endIndent: 10.0,color: Colors.black12),
        _buildItem('视频',Ionicons.videocam,() => {
          onVideo.call()
        }),
      ],
    ));
  }


  static void dismiss() {
    LogUtils.GGQ('====dismiss======>>>${Get.isBottomSheetOpen}');
    if (Get.isBottomSheetOpen == true) {
      Get.back();
    }
  }
}
