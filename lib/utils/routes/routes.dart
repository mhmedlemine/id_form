import 'package:id_form/presentation/home/home.dart';
import 'package:id_form/presentation/login/login.dart';
import 'package:flutter/material.dart';
import 'package:id_form/presentation/mrz_scanner/mrz_scanner.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String mrzScanner = '/mrz_scanner';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen(),
    mrzScanner: (BuildContext context) => MrzScannerScreen(),
  };
}
