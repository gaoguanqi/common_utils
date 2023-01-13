import 'dart:async';

import 'package:event_bus/event_bus.dart';

class EventBusUtils {
  static EventBus? _eventBus;

  //获取单例
  static EventBus _getInstance() {
    if(_eventBus == null) {
      _eventBus = EventBus();
    }
    return _eventBus!;
  }

  //发送事件
  static void send<T extends Event>(T e) {
    _getInstance().fire(e);
  }

  //返回某事件的订阅者
  static StreamSubscription<T> listen<T extends Event>(
      Function(T event) onData) {
    //内部流属于广播模式，可以有多个订阅者
    return _getInstance().on<T>().listen(onData);
  }
}

abstract class Event {}

class CommonEvent extends Event {
  int code;
  String? message;

  CommonEvent(this.code, {this.message});
}
