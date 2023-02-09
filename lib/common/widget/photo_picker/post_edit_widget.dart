import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/utils/utils.dart';
import 'package:common_utils/common/widget/dialog/dialog.dart';
import 'package:common_utils/common/widget/gallery/gallery.dart';
import 'package:common_utils/common/widget/photo_picker/photo_picker.dart';

class PostEditWidget extends StatefulWidget {
  const PostEditWidget({Key? key}) : super(key: key);

  @override
  State<PostEditWidget> createState() => _PostEditWidgetState();
}

class _PostEditWidgetState extends State<PostEditWidget> {

  // 间距
  final double spacing = 10.0;
  // 最多选择的图片数量
  final int maxAssets = 6;

  // 选取时边框描边
  // final Color accentColor = Colors.blue;

  // 图片边框
  final double imagePadding = 1.0;

  List<AssetEntity> selectedAssets = [];

  // 是否开始拖拽
  bool isDragNow = false;

  // 是否将要删除
  bool isWillRemove = false;

  // 是否将要排序
  bool isWillOrder = false;

  // 被拖拽到 id
  String targetAssetId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("发布"),
      ),
      body: _bodyView(),
      bottomSheet: isDragNow ? _buildDeleteBar() : null
    );
  }

  Widget _bodyView() {
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
          final double width =
              (constraints.maxWidth - spacing * 2 - imagePadding * 2 * 3) / 3;
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
      onTap: () {
        // 选择相册或拍照
        PhotoDialog.show(() async {
          PhotoDialog.dismiss();
          // 相册
          final List<AssetEntity>? assetResult = await AssetPicker.pickAssets(
            context,
            pickerConfig: AssetPickerConfig(
              selectedAssets: selectedAssets,
              maxAssets: maxAssets,
            ),
          );
          if(assetResult == null) return;
            setState(() {
              selectedAssets = assetResult;
              /// 测试网络图片的预览功能
              // selectedAssets.add(AssetEntity(id: UniqueKey().toString(), typeInt: AssetType.image.index,title: 'network',relativePath: 'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png',width: 0,height: 0));
            });
        },() {
          PhotoDialog.dismiss();
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

  /// 图片项
  Widget _buildPhotoItem(AssetEntity asset, double width) {
    return Draggable<AssetEntity>(
      // 拖放的数据
      data: asset,
      // 当可拖动对象开始被拖动时调用。
      onDragStarted: () {
        setState(() {
          isDragNow = true;
        });
      },
     // 当可拖动对象被放下时调用。
      onDragEnd: (DraggableDetails details) {
        setState(() {
          isDragNow = false;
          isWillOrder = false;
        });
      },
     // 当 draggable 被放置并被 [DragTarget] 接受时调用。
      onDragCompleted: () {

      },
      // 当 draggable 被放置但未被 [DragTarget] 接受时调用。
      onDraggableCanceled: (Velocity velocity, Offset offset) {
        setState(() {
          isDragNow = false;
          isWillOrder = false;
        });
      },
      // 当正在进行一个或多个拖动时显示的小部件而不是 [child]。
      childWhenDragging: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Opacity(
          opacity: 0.2,
          child: _buildImage(asset, width),
        ),
      ),
      // 拖动进行时显示在指针下方的小部件。
      feedback: _buildPhotoImage(false,asset,width),
      child: DragTarget<AssetEntity>(
        builder: (context, candidateData, rejectedData) {
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
              return GalleryWidget(
                  isBarVisible: true,
                  initialIndex: selectedAssets.indexOf(asset),
                  items: selectedAssets);}),
            ),
            child: _buildPhotoImage(true,asset,width),
          );
        },

        onWillAccept: (data){
          setState(() {
            isWillOrder = true;
            targetAssetId = asset.id;
          });
          return true;
        },
        onAccept: (data) {
          // 0 当前元素位置
          int targetIndex = selectedAssets.indexWhere((element) {
            return element.id == asset.id;
          });

          // 1 删除原来的
          selectedAssets.removeWhere((element) {
            return element.id == data.id;
          });

          // 2 插入到目标前面
          selectedAssets.insert(targetIndex, data);

          setState(() {
            isWillOrder = false;
            targetAssetId = '';
          });
        },
        onLeave: (data) {
          setState(() {
            isWillOrder = false;
            targetAssetId = '';
          });
        }
      ),
    );
  }

  Widget _buildImage(AssetEntity item,double width) {
    return PickerUtils.isNetworkImage(item.title)? ImageLoader.load(url: item.relativePath??'',width: width,height: width): AssetEntityImage(
      item,
      width: width,
      height: width,
      fit: BoxFit.cover,
      isOriginal: false,
    );
  }

  Widget _buildPhotoImage(bool isChange,AssetEntity asset,double size) {
    if(isChange) {
      return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0)
          ),
          child: _buildImage(asset,size));
    } else {
      return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0)
          ),
          child: _buildImage(asset,size));
    }
  }


  // 底部删除bar
  Widget _buildDeleteBar() {
    return DragTarget<AssetEntity>(
      // 调用以构建此小部件的内容。
      builder: (context, candidateData, rejectedData) {
        return SizedBox(
          width: double.infinity,
          child: Container(
            color: isWillRemove ? Colors.red[300] : Colors.red[200],
            height: 120.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 图标
                Icon(
                  Icons.delete,
                  color: isWillRemove ? Colors.white : Colors.white70,
                  size: 24.0,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                // 文字
                Text(
                  "拖拽到这里删除",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: isWillRemove ? Colors.white : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      },

      // 调用以确定此小部件是否有兴趣接收给定的 被拖动到这个拖动目标上的数据片段。
      onWillAccept: (data) {
        setState(() {
          isWillRemove = true;
        });
        return true;
      },

      // 当一条可接受的数据被拖放到这个拖动目标上时调用。
      onAccept: (data) {
        selectedAssets.remove(data);
        setState(() {
          isWillRemove = false;
        });
      },

      // 当被拖动到该目标上的给定数据离开时调用 目标。
      onLeave: (data) {
        setState(() {
          isWillRemove = false;
        });
      },
    );
  }
}
