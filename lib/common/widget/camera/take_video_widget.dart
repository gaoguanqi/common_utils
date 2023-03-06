import 'dart:io';

import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/widget/camera/camera.dart';
import 'package:common_utils/common/widget/photo_picker/photo_picker.dart';

class TakeVideoWidget extends StatefulWidget {
  const TakeVideoWidget({Key? key, required this.cameraState, this.maxVideoDuration}) : super(key: key);

  final CameraState cameraState;
  final Duration? maxVideoDuration;

  @override
  State<TakeVideoWidget> createState() => _TakeVideoWidgetState();
}

class _TakeVideoWidgetState extends State<TakeVideoWidget> {

  @override
  void initState() {
    widget.cameraState.captureState$.listen((event) async {
      if (event != null && event.status == MediaCaptureStatus.success) {
        String filePath = event.filePath;
        String fileTitle = filePath.split('/').last;
        File file = File(filePath);

        // 转换 AssetEntity
        final AssetEntity? asset = await PhotoManager.editor.saveVideo(
          file,
          title: fileTitle,
        );

        // 删除临时文件
        await file.delete();

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
        height: 150.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 切换摄像头
            AwesomeCameraSwitchButton(state: widget.cameraState),
            // 拍摄按钮
            AwesomeCaptureButton(state: widget.cameraState),
            // 倒计时
            if (widget.cameraState is VideoRecordingCameraState &&
                widget.maxVideoDuration != null)
              CountdownWidget(
                time: widget.maxVideoDuration!,
                callback: () {
                  (widget.cameraState as VideoRecordingCameraState)
                      .stopRecording();
                },
              )
            else
              const SizedBox(width: 32 + 20 * 2),
          ],
        ),
      ),
    );
  }
}
