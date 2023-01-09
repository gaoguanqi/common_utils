import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/widget/state/state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class BaseGetController extends GetxController {

  /// 加载状态
  var loadState = LoadState.loading;

  ///  允许下拉
  bool _enablePullDown = true;
  bool get enablePullDown => _enablePullDown;
  void setPullDown(bool value) => _enablePullDown = value;

  ///  允许上拉加载
  bool _enablePullUp = false;
  bool get enablePullUp => _enablePullUp;
  void setPullUp(bool value) => _enablePullUp = value;

  @override
  void onInit() {
    super.onInit();
  }

  void networkChanged(ConnectivityResult status) {}

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void initPullLoading(){
    updateRefresh();
  }

  void onRetry(){
    updateRefresh();
  }

  void onRefresh() {
    updateRefresh();
  }

  void onLoadMore() {
    updateRefresh();
  }

  void updateRefresh(){
     update(['refresh']);
  }


// void onRefresh() {
//   DelayedUtils.delayed(() {
//     if(_refreshController.isRefresh){
//       _refreshController.refreshCompleted(resetFooterState: true);
//     }
//   });
// }
// final Random random = Random();
//
// void onLoadMore() {
//   final num = random.nextInt(3); // 0,1,2
//   DelayedUtils.delayed(() {
//     if(_refreshController.isLoading){
//       if(num == 1) {
//         _refreshController.loadNoData();
//       } else if(num == 2){
//         _refreshController.loadFailed();
//       } else {
//         _refreshController.loadComplete();
//       }
//     }
//   });
// }
}