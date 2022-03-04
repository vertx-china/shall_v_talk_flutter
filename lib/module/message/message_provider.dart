import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/base/base_change_notifier.dart';
import 'package:shall_v_talk_flutter/model/message.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_provider.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_socket_client.dart';

class MessageProvider extends BaseChangeNotifier {
  final TextEditingController textEditingController = TextEditingController();
  final List<Message> messages = [];
 // List<Message> get messages => _messages.reversed.toList();
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
    var vTalkProvider = context.read<VTalkProvider>();
    var nickname = vTalkProvider.nickname;
    textEditingController.clear();
    Message data = VTalkSocketClient.client.sendMessage(message);
    data.nickname = nickname;
    messages.add(data);
    notifyListeners();
  }
}
