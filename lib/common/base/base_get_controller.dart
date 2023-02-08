import 'package:common_utils/common_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'base.dart';

class BaseGetController extends GetxController {

  /// 是否开启多状态视图
  bool enablePageState = false;

  /// 加载状态
  MLoadState _pageState = MLoadState.loading;
  MLoadState get pageState => _pageState;
  void setPageState(MLoadState state) {
    _pageState = state;
  }


  //
  // ///  允许下拉
  // bool _enablePullDown = true;
  // bool get enablePullDown => _enablePullDown;
  // void setPullDown(bool value) => _enablePullDown = value;
  //
  // ///  允许上拉加载
  // bool _enablePullUp = false;
  // bool get enablePullUp => _enablePullUp;
  // void setPullUp(bool value) => _enablePullUp = value;

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
    setPageState(MLoadState.loading);
    enablePageState = false;
    super.onClose();
  }


  void showPageLoading() {
    setPageState(MLoadState.loading);
    _updateState();
  }

  void showPageEmpty() {
    setPageState(MLoadState.empty);
    _updateState();
  }

  void showPageError() {
    setPageState(MLoadState.error);
    _updateState();
  }

  void showPageSuccess() {
    setPageState(MLoadState.success);
    _updateState();
  }

  void onPageRetry(){
    showPageLoading();
  }

  void _updateState(){
     update([IDKey.PAGE_STATE]);
  }
}