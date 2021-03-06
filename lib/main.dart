import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dietari/utils/routes.dart';
import 'package:dietari/utils/strings.dart';
import 'package:dietari/utils/themes.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'data/Register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Register.regist();
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: app_name,
      theme: light,
      initialRoute: login_route,
      routes: getApplicationRoutes(),
    );
  }
}
