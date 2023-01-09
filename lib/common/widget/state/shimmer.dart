import 'package:common_utils/common/utils/screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  ShimmerWidget({Key? key, this.width, this.height, this.radius})
      : super(key: key);

  double? width;
  double? height;
  double? radius;

  final Color baseColor = Colors.grey.shade100;
  final Color highlightColor = Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width ?? getScaleWidth(0.82),
        height: height ?? getHeight(32.0),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(radius ?? 4.0),
        ),
      ),
    );
  }
}
