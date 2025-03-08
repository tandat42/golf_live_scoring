import 'package:flutter/cupertino.dart';

mixin Initializable {
  bool _initialized = false;

  @protected
  set initialized(bool value) => _initialized = value;

  bool get initialized => _initialized;
}