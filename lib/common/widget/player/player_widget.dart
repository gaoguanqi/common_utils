import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/utils/compress_utils.dart';
import 'package:common_utils/common/utils/toast.dart';
import 'package:common_utils/common/widget/photo_picker/photo_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';


class PlayerWidget extends StatefulWidget {

  const PlayerWidget({Key? key, this.controller, this.initAsset, this.onCompleted}) : super(key: key);

  /// chewie 视频播放控制器
  final ChewieController? controller;

  /// 视频 asset
  final AssetEntity? initAsset;

  /// 完成压缩回调
  final Function(CompressMediaFile)? onCompleted;

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {

  // 强调色
   final Color _accentColor = Colors.blueAccent;

  // 次文字颜色
   final Color _secondaryTextColor = Colors.black45;

  /// video 视频控制器
  VideoPlayerController? _videoController;

  /// chewie 控制器
  ChewieController? _controller;

  /// 压缩消息订阅
  Subscription? _subscription;

  /// 资源 asset
  AssetEntity? _asset;

  /// 是否载入中
  bool _isLoading = true;

  /// 是否错误
  bool _isError = false;

  /// 压缩进度
  double _progress = 0;

  @override
  void initState() {
    _asset = widget.initAsset;
    // 压缩进度订阅
    _subscription = VideoCompress.compressProgress$.subscribe((progress) {
      debugPrint('progress: $progress');
      setState(() {
        _progress = progress;
      });
    });
    if (mounted) onLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _bodyView();
  }

  /// 文件 file
  Future<File> getFile() async {
    var file = await _asset?.file;
    if (file == null) throw 'No file';
    return file;
  }

  void onLoad() async {
    // 1. 初始界面状态
    setState(() {
      _isLoading = _asset != null;
      _isError = _asset == null;
    });

    // 2. 安全检查, 容错
    if (_asset == null) return;

    // 3. 清理资源，释放播放器对象
    _videoController?.dispose();

    //
    try {
      final file = await getFile();

      // 开始视频压缩
      final result = await CompressUtils.compressVideo(file);

      // video_player 初始化
      _videoController = VideoPlayerController.file(result.video!.file!);
      await _videoController!.initialize();

      // chewie 初始化
      _controller = widget.controller ??
          ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: false,
            looping: false,
            autoInitialize: true,
            showOptions: false,
            cupertinoProgressColors: ChewieProgressColors(
              playedColor: _accentColor,
            ),
            materialProgressColors: ChewieProgressColors(
              playedColor: _accentColor,
            ),
            allowPlaybackSpeedChanging: false,
            deviceOrientationsOnEnterFullScreen: [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
              DeviceOrientation.portraitUp,
            ],
            deviceOrientationsAfterFullScreen: [
              DeviceOrientation.portraitUp,
            ],
          );
      if (widget.onCompleted != null) widget.onCompleted!(result);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      ToastUtils.showToast('video file error');
      setState(() {
        _isError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


   Widget _bodyView() {
     // 默认空组件
     Widget ws = const SizedBox.shrink();

     // 正在载入
     if (_isLoading) {
       ws = Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           // 进度状态 icon
           Container(
             height: 32.0,
             width: 32.0,
             alignment: Alignment.center,
             child: CircularProgressIndicator(
               strokeWidth: 2.0,
               color: _accentColor,
             ),
           ),
           const SizedBox(height: 10.0),
           // 进度状态文本
           Text(
             '${_progress.toStringAsFixed(2)}%',
             style: TextStyle(
               fontSize: 14.0,
               fontWeight: FontWeight.bold,
               color: _secondaryTextColor,
             ),
           ),
         ],
       );
     }

     // 正确显示
     else {
       if (_controller != null && !_isError) {
         ws = Container(
           decoration: const BoxDecoration(color: Colors.black),
           child: Chewie(controller: _controller!),
         );
       } else {}
     }

     // 按比例组件包裹
     return AspectRatio(
       aspectRatio: 16 / 9,
       child: Container(
         color: Colors.grey[100],
         child: ws,
       ),
     );
   }

   @override
   void dispose() {
     _videoController?.dispose();
     if (widget.controller == null) _controller?.dispose();
     VideoCompress.cancelCompression();
     _subscription?.unsubscribe();
     _subscription = null;
     VideoCompress.deleteAllCache();
     super.dispose();
   }
}
