import 'package:common_utils/common_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class BaseGetController extends GetxController {

  /// 是否开启多状态视图
  bool enablePageState = false;

  /// 加载状态
  LoadState _pageState = LoadState.loading;
  LoadState get pageState => _pageState;
  void setPageState(LoadState state) {
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
      onPageLoading();
    }
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
    setPageState(LoadState.loading);
    enablePageState = false;
    super.onClose();
  }


  void onPageLoading() {
    setPageState(LoadState.loading);
    _updateState();
  }

  void onPageEmpty() {
    setPageState(LoadState.empty);
    _updateState();
  }

  void onPageError() {
    setPageState(LoadState.error);
    _updateState();
  }

  void onPageSuccess() {
    setPageState(LoadState.success);
    _updateState();
  }

  void onPageRetry(){
    onPageLoading();
  }

  void _updateState(){
     update([IDKey.PAGE_STATE]);
  }
}