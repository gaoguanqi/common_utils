import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common_utils.dart';

/// 拍摄、相册
enum PickType { camera, asset }

class BottomPhotoSheet {

  final List<AssetEntity>? selectedAssets;

  BottomPhotoSheet({this.selectedAssets});

  /// 微信发布
  Future<T?> wxPicker<T>({
    required BuildContext context,
  }) {
    return BottomSheetPicker.showModalSheet<T>(
      context: context,
      child: _buildMenuAssetCamera(context),
    );
  }

  Widget _buildMenuAssetCamera(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(KDimens.modalRadius),
            topRight: Radius.circular(KDimens.modalRadius),
          ),
          color: Colors.white
      ),
      padding: const EdgeInsets.only(top: 4.0,bottom: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(text: '拍摄',desc: '照片或视频',icon: Ionicons.camera,onTap: () {
            BottomSheetPicker.showModalSheet(context: context,child: _buildMenuMediaType(context, pickType: PickType.camera),barrierColor: Colors.transparent);
          }),
          const Divider(height: 0.5, thickness: 0.5, indent: 10.0, endIndent: 10.0, color: CSSColors.whiteSmoke),
          _buildItem(text: '相冊',icon: Ionicons.image,onTap: () {
            BottomSheetPicker.showModalSheet(context: context,child: _buildMenuMediaType(context, pickType: PickType.asset),barrierColor: Colors.transparent);
          }),
          const Divider(height: 10.0, thickness: 10.0, color: CSSColors.whiteSmoke),
          _buildCancel(context: context,isResult: false),
        ],
      ),
    );
  }


  Widget _buildMenuMediaType(BuildContext context,{required PickType pickType}){
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(KDimens.modalRadius),
            topRight: Radius.circular(KDimens.modalRadius),
          ),
          color: Colors.white
      ),
      padding: const EdgeInsets.only(top: 4.0,bottom: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(text: '照片',icon: Ionicons.image_outline,onTap: () async {
            List<AssetEntity>? result;
              if (pickType == PickType.asset) {
                result = await PickerUtils.assets(
                  context: context,
                  selectedAssets: selectedAssets,
                  requestType: RequestType.image,
                );
              } else if(pickType == PickType.camera) {
                final asset = await PickerUtils.takePhoto(context);
                if (asset == null) return;
                result = selectedAssets != null ? [...selectedAssets!, asset] : [asset];
              }
              _popRoute(context, isResult: true,result: result);
          }),
          const Divider(height: 0.5, thickness: 0.5, indent: 10.0, endIndent: 10.0, color: CSSColors.whiteSmoke),
          _buildItem(text: '视频',icon: Ionicons.videocam,onTap: () async{
            List<AssetEntity>? result;
            if (pickType == PickType.asset) {
              result = await PickerUtils.assets(
                context: context,
                selectedAssets: selectedAssets,
                requestType: RequestType.video,
                maxAssets: 1,
              );
            } else if (pickType == PickType.camera) {
              final asset = await PickerUtils.takeVideo(context);
              if (asset == null)  return;
              result = [asset];
            }
            _popRoute(context, isResult: true, result: result);
          }),
          const Divider(height: 10.0, thickness: 10.0, color: CSSColors.whiteSmoke),
          _buildCancel(context: context,isResult: true),
        ],
      ),
    );
  }

  Widget _buildItem({required String text,String? desc,IoniconsData? icon,Function()? onTap}) {
    return MaterialButton(
        height: 42.0,
        highlightColor: CSSColors.snow,
        onPressed: onTap,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 12.0,
                  backgroundColor: Colors.black12,
                  child: Icon(icon,
                      color: Colors.black54, size: 16.0)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text( text,style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                  ),
                  Offstage(
                    offstage: (desc == null || desc.isEmpty),
                    child: Text( desc?? '',style: const TextStyle(
                        fontSize: 8.0,
                        color: Colors.black26),
                    ),
                  )
                ],
              )]));
  }

  Widget _buildCancel({required BuildContext context, String? text,bool? isResult}) {
    return MaterialButton(
        height: 42.0,
        highlightColor: CSSColors.snow,
        onPressed: () => _popRoute(context,isResult: isResult),
        child: Center(
          child: Text(
            text?? '取消',
            style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
        ));
  }


  // 弹出路由到顶层
  void _popRoute(BuildContext context, {bool? isResult, result}) {
    Navigator.pop(context);
    if(isResult?? false) {
      Navigator.pop(context, result);
    }
  }

  // static Future<List<AssetEntity>?> show({
  //   required BuildContext context,
  //   List<AssetEntity>? selectedAssets,
  //   int? maxAssets,
  //   RequestType requestType = RequestType.image, // 默认图片
  // }) {
  //   return BottomSheetPicker.showModalSheet<List<AssetEntity>?>(
  //       context: context,
  //       child: Container(
  //         decoration: const BoxDecoration(
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(KDimens.modalRadius),
  //               topRight: Radius.circular(KDimens.modalRadius),
  //             ),
  //           color: Colors.white
  //         ),
  //         padding: const EdgeInsets.only(top: 4.0,bottom: 20.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             MaterialButton(
  //                 height: 42.0,
  //                 highlightColor: CSSColors.snow,
  //                 onPressed: () async{
  //                   final result = await PickerUtils.assets(context: context,selectedAssets: selectedAssets,maxAssets: maxAssets,requestType: requestType);
  //                   Navigator.pop(context,result);
  //                 },
  //                 child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: const [
  //                       CircleAvatar(
  //                           radius: 12.0,
  //                           backgroundColor: Colors.black12,
  //                           child: Icon(Ionicons.image,
  //                               color: Colors.black54, size: 16.0)),
  //                       Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
  //                       Text(
  //                         '相册',
  //                         style: TextStyle(
  //                             fontSize: 12.0,
  //                             color: Colors.black54,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ])),
  //             const Divider(
  //                 height: 0.5,
  //                 thickness: 0.5,
  //                 indent: 10.0,
  //                 endIndent: 10.0,
  //                 color: CSSColors.whiteSmoke),
  //             MaterialButton(
  //                 height: 42.0,
  //                 highlightColor: CSSColors.snow,
  //                 onPressed: () async{
  //                   final result = await PickerUtils.takePhoto(context);
  //                   Navigator.pop(context,result);
  //                 },
  //                 child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: const [
  //                       CircleAvatar(
  //                           radius: 12.0,
  //                           backgroundColor: Colors.black12,
  //                           child: Icon(Ionicons.camera,
  //                               color: Colors.black54, size: 16.0)),
  //                       Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
  //                       Text(
  //                         '拍照',
  //                         style: TextStyle(
  //                             fontSize: 12.0,
  //                             color: Colors.black54,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ])),
  //             const Divider(
  //                 height: 0.5,
  //                 thickness: 0.5,
  //                 indent: 10.0,
  //                 endIndent: 10.0,
  //                 color: CSSColors.whiteSmoke),
  //             MaterialButton(
  //                 height: 42.0,
  //                 highlightColor: CSSColors.snow,
  //                 onPressed: () async {
  //                   final result = await PickerUtils.takeVideo(context);
  //                   Navigator.pop(context,result);
  //                 },
  //                 child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: const [
  //                       CircleAvatar(
  //                           radius: 12.0,
  //                           backgroundColor: Colors.black12,
  //                           child: Icon(Ionicons.videocam,
  //                               color: Colors.black54, size: 16.0)),
  //                       Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
  //                       Text(
  //                         '视频',
  //                         style: TextStyle(
  //                             fontSize: 12.0,
  //                             color: Colors.black54,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ])),
  //             const Divider(
  //                 height: 10.0,
  //                 thickness: 10.0,
  //                 color: CSSColors.whiteSmoke),
  //             MaterialButton(
  //                 height: 42.0,
  //                 highlightColor: CSSColors.snow,
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Center(
  //                   child: Text(
  //                     '取消',
  //                     style: TextStyle(
  //                         fontSize: 14.0,
  //                         color: Colors.black54,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                 )),
  //           ],
  //         ),
  //       ));
  // }
  //
  //
  // static List<AssetEntity>? show({
  //   required BuildContext context,
  //   List<AssetEntity>? selectedAssets,
  //   int? maxAssets,
  //   RequestType requestType = RequestType.image, // 默认图片
  // }) async {
  //   await BottomSheetPicker.showModalSheet<List<AssetEntity>?>(
  //       context: context,
  //       child: Container(
  //         decoration: const BoxDecoration(
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(KDimens.modalRadius),
  //               topRight: Radius.circular(KDimens.modalRadius),
  //             ),
  //             color: Colors.white
  //         ),
  //         padding: const EdgeInsets.only(top: 4.0,bottom: 20.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             MaterialButton(
  //                 height: 42.0,
  //                 highlightColor: CSSColors.snow,
  //                 onPressed: () async{
  //                   final result = await PickerUtils.assets(context: context,selectedAssets: selectedAssets,maxAssets: maxAssets,requestType: requestType);
  //                   Navigator.pop(context,result);
  //                 },
  //                 child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: const [
  //                       CircleAvatar(
  //                           radius: 12.0,
  //                           backgroundColor: Colors.black12,
  //                           child: Icon(Ionicons.image,
  //                               color: Colors.black54, size: 16.0)),
  //                       Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
  //                       Text(
  //                         '相册',
  //                         style: TextStyle(
  //                             fontSize: 12.0,
  //                             color: Colors.black54,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ])),
  //             const Divider(
  //                 height: 0.5,
  //                 thickness: 0.5,
  //                 indent: 10.0,
  //                 endIndent: 10.0,
  //                 color: CSSColors.whiteSmoke),
  //             MaterialButton(
  //                 height: 42.0,
  //                 highlightColor: CSSColors.snow,
  //                 onPressed: () async{
  //                   final result = await PickerUtils.takePhoto(context);
  //                   Navigator.pop(context,result);
  //                 },
  //                 child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: const [
  //                       CircleAvatar(
  //                           radius: 12.0,
  //                           backgroundColor: Colors.black12,
  //                           child: Icon(Ionicons.camera,
  //                               color: Colors.black54, size: 16.0)),
  //                       Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
  //                       Text(
  //                         '拍照',
  //                         style: TextStyle(
  //                             fontSize: 12.0,
  //                             color: Colors.black54,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ])),
  //             const Divider(
  //                 height: 0.5,
  //                 thickness: 0.5,
  //                 indent: 10.0,
  //                 endIndent: 10.0,
  //                 color: CSSColors.whiteSmoke),
  //             MaterialButton(
  //                 height: 42.0,
  //                 highlightColor: CSSColors.snow,
  //                 onPressed: () async {
  //                   final result = await PickerUtils.takeVideo(context);
  //                   Navigator.pop(context,result);
  //                 },
  //                 child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: const [
  //                       CircleAvatar(
  //                           radius: 12.0,
  //                           backgroundColor: Colors.black12,
  //                           child: Icon(Ionicons.videocam,
  //                               color: Colors.black54, size: 16.0)),
  //                       Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
  //                       Text(
  //                         '视频',
  //                         style: TextStyle(
  //                             fontSize: 12.0,
  //                             color: Colors.black54,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ])),
  //             const Divider(
  //                 height: 10.0,
  //                 thickness: 10.0,
  //                 color: CSSColors.whiteSmoke),
  //             MaterialButton(
  //                 height: 42.0,
  //                 highlightColor: CSSColors.snow,
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Center(
  //                   child: Text(
  //                     '取消',
  //                     style: TextStyle(
  //                         fontSize: 14.0,
  //                         color: Colors.black54,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                 )),
  //           ],
  //         ),
  //       )).then((value) {});
  //   return null;
  // }



  static buildDivider({double? height,double? indent}) {
    return Divider(height: height,thickness: height,indent: indent,endIndent: indent,color: CSSColors.whiteSmoke);
  }
  static buildItem({required String text,IoniconsData? icon,VoidCallback? onPressed}) {
    return MaterialButton(
        height: 42.0,
        highlightColor: CSSColors.snow,
        onPressed: () => onPressed?.call(),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 12.0,
                  backgroundColor: Colors.black12,
                  child: Icon(icon,
                      color: Colors.black54, size: 16.0)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
              Text( text,style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
              )]));
  }

  static buildCancel({required BuildContext context, String? text}) {
    return MaterialButton(
        height: 42.0,
        highlightColor: CSSColors.snow,
        onPressed: () => Navigator.pop(context),
        child: Center(
          child: Text(
            text?? '取消',
            style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

}
