import 'package:common_utils/common_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'base.dart';

class BaseGetController extends GetxController {

  /// 是否开启多状态视图
  bool _enablePageState = false;
  bool get enablePageState => _enablePageState;
  set enablePageState(bool value) => _enablePageState = value;
  /// 多状态视图 加载状态
  MLoadState _pageState = MLoadState.loading;
  MLoadState get pageState => _pageState;
  set pageState(MLoadState value) => _pageState = value;


  // 下拉刷新组件
  RefreshState _refreshState = RefreshState.first;
  RefreshState get refreshState => _refreshState;
  set refreshState(RefreshState value) => _refreshState = value;

  ///  允许下拉
  bool _enablePullDown = true;
  bool get enablePullDown => _enablePullDown;
  set enablePullDown(bool value) => _enablePullDown = value;
  ///  允许上拉加载
  bool _enablePullUp = false;
  bool get enablePullUp => _enablePullUp;
  set enablePullUp(bool value) => _enablePullUp = value;


  @override
  void onInit() {
    if(enablePageState) {
      showPageLoading();
    }
    super.onInit();
  }

  void onBack({ String? result }) {
    if(result != null) {
      Get.back(result: {'result': result});
    } else {
      Get.back();
    }
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
    if(enablePageState) {
      pageState = MLoadState.loading;
      enablePageState = false;
    }
    super.onClose();
  }


  void showPageLoading() {
    pageState = MLoadState.loading;
    updatePageState();
  }

  void showPageEmpty() {
    pageState = MLoadState.empty;
    updatePageState();
  }

  void showPageError() {
    pageState = MLoadState.error;
    updatePageState();
  }

  void showPageSuccess() {
    pageState = MLoadState.success;
    updatePageState();
  }

  void onPageRetry(){
    showPageLoading();
  }

  void updatePageState(){
     update([IDKey.pageState]);
  }



  void initPullLoading(){
    refreshState = RefreshState.first;
    updateRefresh();
  }

  void onRetry(){
    refreshState = RefreshState.first;
    updateRefresh();
  }

  void onRefresh() {
    refreshState = RefreshState.up;
    updateRefresh();
  }

  void onLoadMore() {
    refreshState = RefreshState.down;
    updateRefresh();
  }

  void updateRefresh(){
    update([IDKey.refresh]);
  }
}