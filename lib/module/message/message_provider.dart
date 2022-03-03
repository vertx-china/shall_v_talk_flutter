import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/base/base_change_notifier.dart';
import 'package:shall_v_talk_flutter/dialog/login_dialog.dart';
import 'package:shall_v_talk_flutter/model/message.dart';
import 'package:shall_v_talk_flutter/user/user_provider.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_socket_client.dart';

class MessageProvider extends BaseChangeNotifier {
  final TextEditingController textEditingController = TextEditingController();
  final List<Message> messages = [];
  final BuildContext context;

  MessageProvider(this.context) {
    _initCallback();
  }

  void _initCallback() {
    VTalkSocketClient.client.addMessageReceiveCallback(_onMessageReceive);
  }

  void _onMessageReceive(Message message) {
    messages.add(message);
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    var userProvider = context.read<UserProvider>();
    await userProvider.checkLoginStatus(VTalkSocketClient.client.socketId!);
    var user = userProvider.getUser();
    textEditingController.clear();
    Message data = VTalkSocketClient.client.sendMessage(message);
    data.id = user.id;
    data.nickname = user.nickname;
    messages.add(data);
    notifyListeners();
  }
}
