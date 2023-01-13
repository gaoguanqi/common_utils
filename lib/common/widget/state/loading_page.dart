
import 'package:common_utils/common/utils/screen.dart';
import 'package:common_utils/common/widget/state/shimmer.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {

  LoadingPage({Key? key,this.constraints}) : super(key: key);

  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Container(
        constraints: constraints,
        alignment: Alignment.center,
        // child: _buildShimmerBody(),
        child: _buildProgressBar(context),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return CircularProgressIndicator(
      color: Theme.of(context).primaryColor,
      strokeWidth: 5.0, //设置进度条的宽
      backgroundColor: Colors.white70, //设置进度条背景颜色
    );
  }

  Widget _buildShimmerBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildBlock(width: 96.0,height: 88.0),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildItem(width: getScaleWidth(0.60),height: 26,radius: 2.0),
                const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                _buildItem(width: getScaleWidth(0.40),height: 26,radius: 2.0),
                const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                _buildItem(width: getScaleWidth(0.20),height: 26,radius: 2.0),
              ],
            )
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        _buildItem(width: getScaleWidth(0.48)),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        _buildItem(width: getScaleWidth(0.68)),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        _buildItem(width: getScaleWidth(0.88)),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        _buildItem(width: getScaleWidth(0.28)),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        _buildItem(width: getScaleWidth(0.68)),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        _buildItem(width: getScaleWidth(0.48)),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        _buildItem(),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        _buildItem(width: getScaleWidth(0.68)),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
        _buildItem(width: getScaleWidth(0.20)),
      ],
    );
  }

  Widget _buildBlock({double? width,double? height,double? radius}) {
    return ShimmerWidget(width: width,height: height,radius: radius);
  }

  Widget _buildItem({double? width,double? height,double? radius}) {
    return ShimmerWidget(width: width,height: height,radius: radius);
  }
}


