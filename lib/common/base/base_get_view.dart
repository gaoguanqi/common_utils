import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/widget/state/state.dart';

abstract class BaseGetView<T extends BaseGetController> extends GetView<T>{
  BaseGetView({Key? key}) : super(key: key);

  Widget buildLoading(){
    return LoadingPage();
  }

  Widget buildEmpty(){
    return const EmptyPage();
  }

  Widget buildError(VoidCallback onRetry) {
    return ErrorPage(onRetry: onRetry);
  }
}