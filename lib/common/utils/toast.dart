import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ToastUtils {

  static void showToast(String? msg){
    if(msg != null && msg.isNotEmpty) {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0
      );
    }
  }

  static void showGetBar(String? msg){
    if(msg != null && msg.isNotEmpty) {
      Get.closeAllSnackbars();
      Get.snackbar('', msg);
    }
  }

  static void showSnackBar(GlobalKey<ScaffoldMessengerState>? key,String? msg) {
    if(key != null && msg != null && msg.isNotEmpty) {
      key.currentState?..removeCurrentSnackBar()..showSnackBar(
        SnackBar(
          backgroundColor: Colors.black54,
          content: Text(msg,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14.0,color: Colors.white),),
          duration: const Duration(milliseconds: 2000),
        ),
      );
    }
  }
}