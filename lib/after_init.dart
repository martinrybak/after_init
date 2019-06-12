library after_init;

import 'package:flutter/widgets.dart';

mixin AfterInitMixin<T extends StatefulWidget> on State<T> {
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    if (!_didInit) {
      didInitState();
      _didInit = true;
    }
    super.didChangeDependencies();
  }

  void didInitState();
}
