import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shall_v_talk_flutter/module/message/message_page.dart';
import 'package:shall_v_talk_flutter/user/user_provider.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shall We Talk',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                lazy: false,
                create: (context) => VTalkProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => UserProvider(context),
              ),
            ],
            child: const MessagePage(),
          );
        }
      ),
    );
  }
}
