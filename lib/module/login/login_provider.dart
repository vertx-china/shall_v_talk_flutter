import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/base/application.dart';
import 'package:shall_v_talk_flutter/base/base_change_notifier.dart';
import 'package:shall_v_talk_flutter/base/routes/routes.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends BaseChangeNotifier {
  final BuildContext context;

  final String ADDRESS = "ip_address";
  final String NICKNAME = "nick_name";
  final TextEditingController internetAddressController =
      TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

  LoginProvider(this.context) {
    createPreference();
  }

  createPreference() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    internetAddressController.text = _preferences.getString(ADDRESS) ?? "";
    nicknameController.text = _preferences.getString(NICKNAME) ?? "";
    notifyListeners();
  }

  //TODO 自动登陆完成退出界面先
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
      var connectFuture = await vTalk.connect(host, port, nickname);
      if (connectFuture) {
        SharedPreferences _preferences = await SharedPreferences.getInstance();
        _preferences.setString(ADDRESS, internetAddressController.text);
        _preferences.setString(NICKNAME, nicknameController.text);
        Application.router.navigateTo(
          context,
          Routes.messagePage,
          clearStack: true,
          transition: TransitionType.inFromRight,
        );
      } else {
        MotionToast.error(description: const Text("登陆失败"));
      }
    } on SocketException catch (e, s) {
      print("链接失败，e=$e");
    } catch (e, s) {
      //

      print('链接失败，e=$s');
    }
  }
}
