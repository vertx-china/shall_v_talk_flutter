import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/module/message/message_page.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => VTalkProvider(),
        ),
      ],
      child: const MaterialApp(
        title: 'Shall We Talk',
        home: MessagePage(),
      ),
    );
  }
}
