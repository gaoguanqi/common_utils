import 'dart:async';

import 'package:common_utils/common/base/base.dart';

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({Key? key, required this.time, required this.callback}) : super(key: key);

  // 倒计时长
  final Duration time;

  // 结束回调
  final Function callback;

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {

  late Duration _currentTime;
  late Timer _timer;

  @override
  void initState() {
    _currentTime = widget.time;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final newTime = _currentTime - const Duration(seconds: 1);
      if (newTime == Duration.zero) {
        widget.callback();
        _timer.cancel();
      } else {
        setState(() {
          _currentTime = newTime;
        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Text(
      '${_currentTime.inSeconds} s',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30.0,
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
