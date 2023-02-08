import 'package:common_utils/common/base/base.dart';
import 'package:common_utils/common/widget/state/state.dart';

class PageStateWidget extends StatelessWidget {

  PageStateWidget({Key? key, required this.child,required this.controller,this.onRetry}) : super(key: key);

  final BaseGetController controller;
  final Widget child;
  final VoidCallback? onRetry;


  @override
  Widget build(BuildContext context) {
    if(!controller.enablePageState) {
      return _buildSuccess(child);
    }
    MLoadState state = controller.pageState;
    if(state == MLoadState.loading) {
      return LayoutBuilder(builder: (BuildContext context,BoxConstraints constraints) => _buildLoading(constraints:constraints));
    } else if(state == MLoadState.empty) {
      return LayoutBuilder(builder: (BuildContext context,BoxConstraints constraints) => _buildEmpty(constraints:constraints));
    } else if(state == MLoadState.error) {
      return LayoutBuilder(builder: (BuildContext context,BoxConstraints constraints) => _buildError(constraints:constraints,onRetry:onRetry));
    } else {
      return _buildSuccess(child);
    }
  }


  Widget _buildSuccess(Widget? child) {
    return child?? const SizedBox.shrink();
  }

  Widget _buildLoading({BoxConstraints? constraints}){
    return LoadingPage(constraints: constraints);
  }

  Widget _buildEmpty({BoxConstraints? constraints}){
    return EmptyPage(constraints: constraints,);
  }

  Widget _buildError({BoxConstraints? constraints,VoidCallback? onRetry}) {
    return ErrorPage(constraints: constraints,onRetry: onRetry);
  }
}
