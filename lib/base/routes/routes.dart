import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shall_v_talk_flutter/module/login/login_page.dart';
import 'package:shall_v_talk_flutter/module/message/message_page.dart';

class Routes{

  Routes._internal();

  static const String loginPage = "/";
  static const String messagePage = "message";

  static var loginHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const LoginPage();
  });

  static var messageHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const MessagePage();
  });

  static void configureRoutes(FluroRouter router) {
    //router.notFoundHandler = emptyHandler;     //空页面
    router.define(loginPage, handler: loginHandler);
    router.define(messagePage, handler: messageHandler);
  }
}