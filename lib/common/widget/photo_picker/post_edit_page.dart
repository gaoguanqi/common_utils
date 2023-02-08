import 'package:common_utils/common/base/base.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostEditPage extends StatefulWidget {
  const PostEditPage({Key? key}) : super(key: key);

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {

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
                _buildAddBtn(context, width),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddBtn(BuildContext context, double width) {
    return GestureDetector(
      onTap: () async {
        final List<AssetEntity>? result = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            selectedAssets: selectedAssets,
            maxAssets: maxAssets,
          ),
        );
        setState(() {
          selectedAssets = result ?? [];
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
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
      ),
      child: AssetEntityImage(
        asset,
        width: width,
        height: width,
        fit: BoxFit.cover,
        isOriginal: false,
      ),
    );
  }
}
