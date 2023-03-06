import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/res/res.dart';
import 'package:common_utils/common/utils/utils.dart';
import 'package:common_utils/common/widget/gallery/gallery.dart';
import 'package:common_utils/common/widget/photo_picker/photo_picker.dart';
import 'package:common_utils/common/widget/player/player.dart';

enum PostType { image, video }

class PostEditWidget extends StatefulWidget {
  const PostEditWidget({Key? key}) : super(key: key);

  @override
  State<PostEditWidget> createState() => _PostEditWidgetState();
}

class _PostEditWidgetState extends State<PostEditWidget> {

  // 发布类型
  PostType? _postType;
// 视频压缩文件
  CompressMediaFile? _videoCompressFile;

  // 间距
  final double _spacing = 10.0;
  // 最多选择的图片数量
  final int _maxAssets = 6;

  // 选取时边框描边
  // final Color accentColor = Colors.blue;

  // 图片边框
  final double _imagePadding = 1.0;

  List<AssetEntity> _selectedAssets = [];

  // 是否开始拖拽
  bool _isDragNow = false;

  // 是否将要删除
  bool _isWillRemove = false;

  // 是否将要排序
  bool _isWillOrder = false;

  // 被拖拽到 id
  String _targetAssetId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布'),
      ),
      body: _bodyView(),
      bottomSheet: _isDragNow ? _buildDeleteBar() : null
    );
  }

  Widget _bodyView() {
    return Column(
      children: [
        // 相册列表
        if (_postType == PostType.image) _buildPhotosList(),

        // 视频播放器
        if (_postType == PostType.video)
          PlayerWidget(
            initAsset: _selectedAssets.first,
            onCompleted: (value) => _videoCompressFile = value,
          ),

        // 添加按钮
        if (_postType == null && _selectedAssets.isEmpty)
          Padding(
            padding: EdgeInsets.all(_spacing),
            child: _buildAddView(context, 100.0),
          ),
      ],
    );
  }

  Widget _buildPhotosList() {
    return Padding(
      padding: EdgeInsets.all(_spacing),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double width =
              (constraints.maxWidth - _spacing * 2 - _imagePadding * 2 * 3) / 3;
          return Wrap(
            spacing: _spacing,
            runSpacing: _spacing,
            children: [
              // 图片
              for (final asset in _selectedAssets) _buildPhotoItem(asset, width),

              // 选着图片按钮
              if (_selectedAssets.length < _maxAssets)
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
        // 选择相册或拍照
        // PhotoDialog.show(() async {
        //   PhotoDialog.dismiss();
        //   // 相册
        //   final List<AssetEntity>? result = await PickerUtils.assets(context: context,selectedAssets: selectedAssets,maxAssets: 6);
        //   if(result == null) return;
        //     setState(() {
        //       selectedAssets = result;
        //       /// 测试网络图片的预览功能
        //       // selectedAssets.add(AssetEntity(id: UniqueKey().toString(), typeInt: AssetType.image.index,title: 'network',relativePath: 'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png',width: 0,height: 0));
        //     });
        // },() async {
        //   PhotoDialog.dismiss();
        //   // 拍照
        //   final asset = await PickerUtils.takePhoto(context);
        //   if(asset == null) return;
        //   setState(() {
        //     selectedAssets.add(asset);
        //   });
        // },() async {
        //   PhotoDialog.dismiss();
        //   // 录视频
        //   final asset = await PickerUtils.takeVideo(context);
        //   if(asset == null) return;
        //   setState(() {
        //     selectedAssets.add(asset);
        //   });
        // });

        // final List<AssetEntity>? result = await PickerUtils.assets(context: context,selectedAssets: selectedAssets,maxAssets: 6,requestType: RequestType.video);
        // if (result == null) {
        //   return;
        // }
        //
        // setState(() {
        //   postType = PostType.video;
        //   selectedAssets = result;
        // });

        // 视频
        // final asset = await PickerUtils.takeVideo(context);
        // if (asset == null) {
        //   return;
        // }
        // setState(() {
        //   postType = PostType.video;
        //   selectedAssets.clear();
        //   selectedAssets.add(asset);
        // });

        // final result = await BottomPhotoSheet(selectedAssets: _selectedAssets)
        //     .wxPicker<List<AssetEntity>>(
        //   context: context,
        // );

        final result = await BottomPhotoSheet(selectedAssets: _selectedAssets).wxPicker(context: context);
        if (result == null || result.isEmpty) return;
        // 视频
        if (result.length == 1 && result.first.type == AssetType.video) {
          setState(() {
            _postType = PostType.video;
            _selectedAssets = result;
          });
        } else { // 图片
          setState(() {
            _postType = PostType.image;
            _selectedAssets = result;
          });
        }

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
          _isDragNow = true;
        });
      },
     // 当可拖动对象被放下时调用。
      onDragEnd: (DraggableDetails details) {
        setState(() {
          _isDragNow = false;
          _isWillOrder = false;
        });
      },
     // 当 draggable 被放置并被 [DragTarget] 接受时调用。
      onDragCompleted: () {

      },
      // 当 draggable 被放置但未被 [DragTarget] 接受时调用。
      onDraggableCanceled: (Velocity velocity, Offset offset) {
        setState(() {
          _isDragNow = false;
          _isWillOrder = false;
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
                  initialIndex: _selectedAssets.indexOf(asset),
                  items: _selectedAssets);}),
            ),
            child: _buildPhotoImage(true,asset,width),
          );
        },

        onWillAccept: (data){
          setState(() {
            _isWillOrder = true;
            _targetAssetId = asset.id;
          });
          return true;
        },
        onAccept: (data) {
          // 0 当前元素位置
          int targetIndex = _selectedAssets.indexWhere((element) {
            return element.id == asset.id;
          });

          // 1 删除原来的
          _selectedAssets.removeWhere((element) {
            return element.id == data.id;
          });

          // 2 插入到目标前面
          _selectedAssets.insert(targetIndex, data);

          setState(() {
            _isWillOrder = false;
            _targetAssetId = '';
          });
        },
        onLeave: (data) {
          setState(() {
            _isWillOrder = false;
            _targetAssetId = '';
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
            color: _isWillRemove ? Colors.red[300] : Colors.red[200],
            height: 120.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 图标
                Icon(
                  Icons.delete,
                  color: _isWillRemove ? Colors.white : Colors.white70,
                  size: 24.0,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                // 文字
                Text(
                  '拖拽到这里删除',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: _isWillRemove ? Colors.white : Colors.white70,
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
          _isWillRemove = true;
        });
        return true;
      },

      // 当一条可接受的数据被拖放到这个拖动目标上时调用。
      onAccept: (data) {
        _selectedAssets.remove(data);
        setState(() {
          _isWillRemove = false;
        });
      },

      // 当被拖动到该目标上的给定数据离开时调用 目标。
      onLeave: (data) {
        setState(() {
          _isWillRemove = false;
        });
      },
    );
  }
}
