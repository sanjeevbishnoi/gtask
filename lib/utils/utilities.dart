import 'package:flutter/material.dart';

class Utilities {
  static bool isKeyboardShowing(BuildContext context) {
    return View.of(context).viewInsets.bottom > 0;
  }

  static closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
