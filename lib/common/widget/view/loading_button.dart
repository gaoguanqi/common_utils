
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingButton extends StatelessWidget {
  LoadingButton({Key? key, required this.controller}) : super(key: key);

  LoadingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: controller.size ?? getDefaultSize(context),
      child: TextButton(
        style: controller.buttonStyle ??
            ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) {
                  if (states.contains(MaterialState.focused) &&
                      !states.contains(MaterialState.pressed)) {
                    return Colors.grey[300];
                  } else if (states.contains(MaterialState.pressed)) {
                    return Colors.white60;
                  }
                  return Colors.white;
                },
              ),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.blueAccent[100];
                }

                if (states.contains(MaterialState.disabled)) {
                  return Colors.blue[100];
                }

                return Colors.blueAccent;
              }),
              shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              )),
            ),
        onPressed: () {
          if(controller.value) return;
          controller.value = !controller.value;
          controller.callback?.onSubmit(controller.value);
        },
        child: ValueListenableBuilder<bool>(
            valueListenable: controller,
            builder: (context, value, _) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: value ? _buildLoading() : _buildTxt())),
      ),
    );
  }

  Widget _buildLoading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 15.0,
          height: 15.0,
          child: SpinKitRing(
            color: controller.loadingColor ?? Colors.white60,
            size: 13.0,
            lineWidth: 1.0,
          ),
        ),
        const Padding(padding: EdgeInsets.only(right: 6.0)),
        Text(controller.loadingTxt ?? '',style: controller.textStyle)
      ],
    );
  }

  Widget _buildTxt() {
    return Text(controller.txt ?? '',style: controller.textStyle);
  }

  Size getDefaultSize(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Size(size.width / 3.0, 42.0);
  }
}

typedef LoadingSubmit = void Function(bool loading);

class LoadingCallback{
  LoadingSubmit onSubmit;
  LoadingCallback(this.onSubmit);
}

class LoadingController extends ValueNotifier<bool> {
  LoadingController(super.value, {this.txt, this.loadingTxt, this.loadingColor, this.size,this.textStyle,this.buttonStyle});

  String? txt;
  String? loadingTxt;
  Color? loadingColor;
  Size? size;
  TextStyle? textStyle;
  ButtonStyle? buttonStyle;

  LoadingCallback? callback;
  void setListener(LoadingCallback call) {
    callback = call;
  }

  void reset() {
    value = false;
  }
}
