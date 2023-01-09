import 'package:flutter/services.dart';

class KeyboardUtils {

  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}