import 'package:common_utils/common/service/config_service.dart';
import 'package:common_utils/common/utils/assets_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, this.constraints, this.onRetry}) : super(key: key);

  final BoxConstraints? constraints;

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Center(
        child: Container(
          constraints: constraints,
          alignment: Alignment.center,
          child: Column(
            children: [
              Lottie.asset(AssetsProvider.lottiePath('page_error'), package: ConfigService.to.getCommonUtilsName()),
              OutlinedButton(
                onPressed: onRetry,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      //设置按下时的背景颜色
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey[200];
                      }
                      //默认不使用背景颜色
                      // return null;
                      return Colors.redAccent[100];
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.focused) &&
                          !states.contains(MaterialState.pressed)) {
                        //获取焦点时的颜色
                        return Colors.blue;
                      } else if (states.contains(MaterialState.pressed)) {
                        //按下时的颜色
                        return Colors.black12;
                      }
                      //默认状态使用灰色
                      return Colors.white;
                    },
                  ),
                ),
                child: const Text(
                  '数据异常，点击重试',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
