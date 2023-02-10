import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/res/res.dart';
import 'package:common_utils/common/widget/camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class CameraWidget extends StatelessWidget {
  const CameraWidget({Key? key, this.captureMode = CaptureMode.photo, this.maxVideoDuration}) : super(key: key);

  /// 拍照、拍视频
  final CaptureMode captureMode;

  /// 视频最大时长 秒
  final Duration? maxVideoDuration;


  // 生成文件路径
  Future<String> _buildFilePath() async {
    // final extDir = await getApplicationDocumentsDirectory();
    final extDir = await getTemporaryDirectory();
    // 扩展名
    final extendName = captureMode == CaptureMode.photo ? 'jpg' : 'mp4';
    return '${extDir.path}/${DateTime.now().millisecondsSinceEpoch}.$extendName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraAwesomeBuilder.custom(
            saveConfig: captureMode == CaptureMode.photo
                ? SaveConfig.photo(pathBuilder: _buildFilePath)
                : SaveConfig.video(pathBuilder: _buildFilePath),
            builder: (cameraState, previewSize, rect) {
              return cameraState.when(
                // 拍照
                onPhotoMode: (state) => TakePhotoWidget(cameraState: state),

                // 拍视频
                onVideoMode: (state) => TakeVideoWidget(
                  cameraState: state,
                  maxVideoDuration: maxVideoDuration,
                ),

                // 拍摄中
                onVideoRecordingMode: (state) => TakeVideoWidget(
                  cameraState: state,
                  maxVideoDuration: maxVideoDuration,
                ),

                // 启动摄像头
                onPreparingCamera: (state) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            // 生成规则
            imageAnalysisConfig: AnalysisConfig(
              outputFormat: InputAnalysisImageFormat.jpeg, // 图像格式
            ),
            // 经纬度, 墙
            // exifPreferences: ExifPreferences(
            //   saveGPSLocation: true,
            // ),
          ),
          Positioned(
              top: 20,
              child: IconButton(
              onPressed: () => Navigator.pop(context),
              splashRadius: KDimens.backRadius,
              icon: Container(
                decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(24.0))
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 22.0,
                ),
              )
          ))
        ],
      ),
    );
  }
}
