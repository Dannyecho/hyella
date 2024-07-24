import 'package:flutter/material.dart';

class DialogUtil {
  static void showLoadingDialog(BuildContext context, {String? text}) {
    showGeneralDialog(
      useRootNavigator: false,
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(.4),
      transitionDuration: const Duration(milliseconds: 100),
      context: context,
      pageBuilder: (BuildContext context, __, ___) {
        return Material(
          type: MaterialType.transparency,
          color: Colors.white,
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
      transitionBuilder: (BuildContext context, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim),
          child: child,
        );
      },
    );
  }

  static void dismissLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
