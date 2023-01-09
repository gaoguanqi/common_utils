import 'package:common_utils/common/utils/assets_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key? key, this.constraints}) : super(key: key);

  final BoxConstraints? constraints;

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
              Lottie.asset(AssetsProvider.lottiePath('page_empty')),
              const Text(
                '暂无数据',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
