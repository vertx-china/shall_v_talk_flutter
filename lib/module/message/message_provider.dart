import 'package:flutter/material.dart';
import 'package:shall_v_talk_flutter/base/base_change_notifier.dart';
import 'package:shall_v_talk_flutter/model/message.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_socket_client.dart';

class MessageProvider extends BaseChangeNotifier {
  final TextEditingController textEditingController = TextEditingController();
  final List<Message> messages = [];

  MessageProvider() {
    _initCallback();
  }

  void _initCallback() {
    VTalkSocketClient.client.addMessageReceiveCallback(_onMessageReceive);
  }

  void _onMessageReceive(Message message) {
    messages.add(message);
    notifyListeners();
  }

  void sendMessage(String message) {
    textEditingController.clear();
    VTalkSocketClient.client.sendMessage(message);
  }
}
