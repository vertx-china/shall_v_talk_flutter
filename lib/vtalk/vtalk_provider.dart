import 'package:flutter/material.dart';
import 'package:shall_v_talk_flutter/base/base_change_notifier.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_socket_client.dart';

class VTalkProvider extends BaseChangeNotifier{

  String nickname = '';

  Future<void> connect(String host , String port, String nickname) async {
    await VTalkSocketClient.client.connect(host , int.parse(port));
    this.nickname = nickname;
    VTalkSocketClient.client.login(nickname);
  }



  @override
  void dispose() {
    VTalkSocketClient.client.dispose();
    super.dispose();
  }

  void showConnectDialog() {

  }
}
