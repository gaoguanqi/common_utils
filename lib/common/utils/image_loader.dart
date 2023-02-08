import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageLoader {
  static Widget load({required String url,final double? width, final double? height, final BoxFit? fit}){
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit?? BoxFit.fill,
      placeholder: (context, url) => UnconstrainedBox(
        child: SizedBox(
          width: 14.0,
          height: 14.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: Theme.of(context).primaryColor,
            backgroundColor: Colors.white70, //设置进度条背景颜色
          ),
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}