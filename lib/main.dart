import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/base/application.dart';
import 'package:shall_v_talk_flutter/base/routes/routes.dart';
import 'package:shall_v_talk_flutter/module/login/login_page.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  FluroRouter router = FluroRouter();
  Routes.configureRoutes(router);
  Application.router = router;
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
      child: MaterialApp(
        title: 'Shall We Talk',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        onGenerateRoute: Application.router.generator,
        theme: ThemeData(primaryColor: const Color(0xFF782a91)),
        home: const LoginPage(),
      ),
    );
  }
}
