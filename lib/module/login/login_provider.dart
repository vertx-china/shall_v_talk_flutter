import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/base/application.dart';
import 'package:shall_v_talk_flutter/base/base_change_notifier.dart';
import 'package:shall_v_talk_flutter/base/routes/routes.dart';
import 'package:shall_v_talk_flutter/module/message/message_page.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_provider.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_socket_client.dart';

class LoginProvider extends BaseChangeNotifier {
  final BuildContext context;

  LoginProvider(this.context);

  final TextEditingController internetAddressController =
      TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

  //TODO 持久化地址，昵称，自动登陆
  Future<void> login() async {
    try {
      List<String> internetAddress = internetAddressController.text.split(':');
      String host = internetAddress[0];
      String port = internetAddress[1];
      String nickname = nicknameController.text;
      print('host=$host, port=$port, ');
      if (host.isEmpty || port.isEmpty || nickname.isEmpty) {
        return;
      }
      var vTalk = context.read<VTalkProvider>();
      await vTalk.connect(host, port, nickname);
      Application.router.navigateTo(
        context,
        Routes.messagePage,
        clearStack: true,
        transition: TransitionType.inFromRight,
      );
    } on SocketException catch (e, s) {
      print('链接失败，e=$e');
    } catch (e , s) {
      //

      print('链接失败，e=$s');
    }
  }
}
