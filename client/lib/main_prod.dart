import 'package:flutter/material.dart';

import 'app.dart';
import 'common/constants.dart';

void main() {
  Constants.setEnvironment(Environment.PROD);
  runApp(App());
}

