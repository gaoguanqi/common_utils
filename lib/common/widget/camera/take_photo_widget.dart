import 'dart:io';

import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/utils/compress_utils.dart';
import 'package:common_utils/common/utils/utils.dart';
import 'package:common_utils/common/widget/camera/camera.dart';
import 'package:common_utils/common/widget/photo_picker/photo_picker.dart';

class TakePhotoWidget extends StatefulWidget {
  const TakePhotoWidget({Key? key, required this.cameraState}) : super(key: key);

  final CameraState cameraState;

  @override
  State<TakePhotoWidget> createState() => _TakePhotoWidgetState();
}

class _TakePhotoWidgetState extends State<TakePhotoWidget> {

  @override
  void initState() {
    widget.cameraState.captureState$.listen((event) async {
      if (event != null && event.status == MediaCaptureStatus.success) {
        String filePath = event.filePath;
        String fileTitle = filePath.split('/').last;
        File file = File(filePath);

        LogUtils.GGQ('----原文件大小:------>>${await file.length()}');
        // 1 压缩图片
        final newFile = await CompressUtils.compressImage(File(filePath));
        if (newFile == null) {
          return;
        }
        LogUtils.GGQ('----压缩文件大小:------>>${await newFile.length()}');

        // 2 转换 AssetEntity
        final AssetEntity? asset = await PhotoManager.editor.saveImage(
          newFile.readAsBytesSync(),
          title: fileTitle,
        );

        // 3 删除临时文件
        await file.delete();
        await newFile.delete();

        // ignore: use_build_context_synchronously
        Navigator.of(context).pop<AssetEntity?>(asset);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.black54,
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 切换摄像头
            AwesomeCameraSwitchButton(state: widget.cameraState),
            // 拍摄按钮
            AwesomeCaptureButton(state: widget.cameraState),
            // 右侧空间
            const SizedBox(width: 32 + 20 * 2),
          ],
        ),
      ),
    );
  }
}
