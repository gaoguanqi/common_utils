import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';


class CompressMediaFile {
  final File? thumbnail;
  final MediaInfo? video;

  CompressMediaFile({
    this.thumbnail,
    this.video,
  });
}
/// 压缩工具
class CompressUtils {

  static Future<File?> compressImage(File file, {int minWidth = 1920, int minHeight = 1080,}) async {

    return await FlutterImageCompress.compressAndGetFile(
      file.path,
      '${file.path}_temp.jpg',
      keepExif: true,
      quality: 80,
      format: CompressFormat.jpeg,
      minHeight: minHeight,
      minWidth: minWidth,
    );
  }

  static Future<CompressMediaFile> compressVideo(File file) async {
    final result = await Future.wait([
      VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.Res640x480Quality,
        deleteOrigin: false, // 默认不要去删除原视频
        includeAudio: true,
        frameRate: 25,
      ),
      VideoCompress.getFileThumbnail(
        file.path,
        quality: 80,
        position: -1,
      ),
    ]);
    return CompressMediaFile(
      video: result.first as MediaInfo,
      thumbnail: result.last as File,
    );
  }

  // 清理缓存
  static Future<bool?> clean() async {
    return await VideoCompress.deleteAllCache();
  }

  // 取消
  static Future<void> cancel() async {
    return await VideoCompress.cancelCompression();
  }
}