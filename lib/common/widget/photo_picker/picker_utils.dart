import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/widget/camera/camera.dart';
import 'package:common_utils/common/widget/camera/camera_widget.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PickerUtils {

  static isNetworkImage(String? title) {
    return (title != null && title == "network");
  }

  // 选择相册
  static Future<List<AssetEntity>?> assets({
    required BuildContext context, List<AssetEntity>? selectedAssets,
    int? maxAssets,
    RequestType requestType = RequestType.image, // 默认图片
  }) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        selectedAssets: selectedAssets,
        requestType: requestType,
        maxAssets: maxAssets?? 6,
      ),
    );
    return result;
  }
  // 选择相机
  static Future<AssetEntity?> takePhoto(BuildContext context) async {
    final result = await Navigator.of(context)
        .push<AssetEntity?>(MaterialPageRoute(builder: (context) {
      return const CameraWidget();
    }));
    return result;
  }

  // 拍摄视频
  static Future<AssetEntity?> takeVideo(BuildContext context) async {
    final filePath = await Navigator.of(context)
        .push<AssetEntity?>(MaterialPageRoute(builder: (context) {
      return const CameraWidget(
        captureMode: CaptureMode.video,
        maxVideoDuration: Duration(seconds: 30),
      );
    }));
    return filePath;
  }
}