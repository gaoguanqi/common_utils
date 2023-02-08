import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/utils/utils.dart';
import 'package:common_utils/common/widget/gallery/gallery.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostEditWidget extends StatefulWidget {
  const PostEditWidget({Key? key}) : super(key: key);

  @override
  State<PostEditWidget> createState() => _PostEditWidgetState();
}

class _PostEditWidgetState extends State<PostEditWidget> {

  // 间距
  final double spacing = 10.0;

// 图片选取数量
  final int maxAssets = 6;

  List<AssetEntity> selectedAssets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("发布"),
      ),
      body: _mainView(),
    );
  }

  Widget _mainView() {
    return Column(
      children: [
        // 图片列表
        _buildPhotosList(),
      ],
    );
  }

  Widget _buildPhotosList() {
    return Padding(
      padding: EdgeInsets.all(spacing),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double width = (constraints.maxWidth - spacing * 2) / 3;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              // 图片
              for (final asset in selectedAssets) _buildPhotoItem(asset, width),

              // 选着图片按钮
              if (selectedAssets.length < maxAssets)
                _buildAddView(context, width),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddView(BuildContext context, double width) {
    return GestureDetector(
      onTap: () async {
        final List<AssetEntity>? result = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            selectedAssets: selectedAssets,
            maxAssets: maxAssets,
          ),
        );
        if(result == null) return;
        setState(() {
          // selectedAssets = result;
          selectedAssets.add(AssetEntity(id: UniqueKey().toString(), typeInt: AssetType.image.index,title: 'network',relativePath: 'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png',width: 0,height: 0));
        });
      },
      child: Container(
        color: Colors.black12,
        width: width,
        height: width,
        child: const Icon(
          Icons.add,
          size: 48,
          color: Colors.black38,
        ),
      ),
    );
  }

  Widget _buildPhotoItem(AssetEntity asset, double width) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
        return GalleryWidget(
            isBarVisible: true,
            initialIndex: selectedAssets.indexOf(asset),
            items: selectedAssets);}),
      ),
      child: _buildImage(asset,width),
    );
  }

  Widget _buildImage(AssetEntity item,double width) {
    return (item.title != null && item.title == "network")? ImageLoader.load(url: item.relativePath??'',width: width,height: width): AssetEntityImage(
      item,
      width: width,
      height: width,
      fit: BoxFit.cover,
      isOriginal: false,
    );
  }
}
