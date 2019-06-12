library after_init;

import 'package:flutter/widgets.dart';

/// This mixin adds a [didInitState] method to a [StatefulWidget] [State] object.
/// From there you can safely access [BuildContext.inheritFromWidgetOfExactType].
mixin AfterInitMixin<T extends StatefulWidget> on State<T> {
  bool _didInitState = false;

  @override
  void didChangeDependencies() {
    if (!_didInitState) {
      didInitState();
      _didInitState = true;
    }
    super.didChangeDependencies();
  }

  /// This will only be invoked once, after [initState], and before [didChangeDependencies].
  void didInitState();
}
