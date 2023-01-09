
import 'package:common_utils/common/utils/assets_provider.dart';
import 'package:common_utils/common/utils/screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Center(
        child: Container(
          constraints: BoxConstraints.tight(screenSize()),
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(width: 200,height: 300),
            child: Column(
              children: [
                Lottie.asset(AssetsProvider.lottiePath('page_empty')),
                const Text('暂无数据',style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ))
              ],
            ),
          )
        ),
      ),
    );
  }
}
