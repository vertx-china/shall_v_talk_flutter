import 'package:flutter/material.dart';
import 'package:shall_v_talk_flutter/base/base_change_notifier.dart';
import 'package:shall_v_talk_flutter/dialog/login_dialog.dart';
import 'package:shall_v_talk_flutter/model/user.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_socket_client.dart';

class UserProvider extends BaseChangeNotifier {
  final BuildContext context;
  User? _user;

  UserProvider(this.context);

  Future<void> checkLoginStatus(String socketId) async {
    if (_user == null) {
      String nickname = await login();
      _user = User(
        id: socketId,
        nickname: nickname.isEmpty ? socketId : nickname,
      );
    }
  }

  User getUser() {
    return _user!;
  }

  Future<String> login() async {
    String nickname = await showDialog(
      context: context,
      builder: (context) => const LoginDialog(),
    );
    VTalkSocketClient.client.login(nickname);
    return nickname;
  }
}
