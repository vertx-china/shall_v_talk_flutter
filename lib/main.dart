import 'package:flutter/material.dart';
import 'package:shall_v_talk_flutter/module/login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shall We Talk',
      home: LoginPage(),
    );
  }
}

