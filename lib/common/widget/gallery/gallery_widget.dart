import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/res/res.dart';
import 'package:common_utils/common/widget/appbar/appbar.dart';
import 'package:common_utils/common/widget/gallery/gallery.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget(
      {Key? key,
      required this.isBarVisible,
      required this.initialIndex,
      required this.items})
      : super(key: key);

  final bool isBarVisible;

  // 初始图片位置
  final int initialIndex;

  // 图片列表
  final List<AssetEntity> items;

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget>
    with SingleTickerProviderStateMixin {
  bool visible = true;

  // 动画控制器
  late final AnimationController controller;

  @override
  void initState() {
    visible = widget.isBarVisible;
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _bodyView();
  }

  Widget _bodyView() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          visible = !visible;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: SlideAppBarWidget(
          visible: visible,
          controller: controller,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
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
            ),
          ),
        ),
        body: _buildImageView(),
      ),
    );
  }

  Widget _buildImageView() {
    return ExtendedImageGesturePageView.builder(
      controller: ExtendedPageController(
        initialPage: widget.initialIndex,
      ),
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {
        final AssetEntity item = widget.items[index];
        final ImageProvider image = (item.title != null && item.title == "network")? _buildNetworkImage(item): _buildAssetImage(item);
        return ExtendedImage(
          image: image,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          initGestureConfigHandler: ((state) {
            return GestureConfig(
              minScale: 0.9,
              animationMinScale: 0.7,
              maxScale: 3.0,
              animationMaxScale: 3.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              inPageView: true, // 是否使用 ExtendedImageGesturePageView 展示图片
            );
          }),
        );
      },
    );
  }

  ImageProvider _buildAssetImage(AssetEntity item) {
    return AssetEntityImageProvider(item, isOriginal: true);
  }

  ImageProvider _buildNetworkImage(AssetEntity item) {
    return NetworkImage(item.relativePath??'');
  }

}
