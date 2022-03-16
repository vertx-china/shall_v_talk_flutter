import 'package:flutter/material.dart';
import 'package:shall_v_talk_flutter/model/message.dart';

abstract class VTalkClient {
  Future<bool> connect(String host, int port);

  void login(String nickname);

  Message sendTextMessage(String message);

  void addNicknamesChangeCallback(ValueChanged<List<String>> callback);

  void addMessageReceiveCallback(ValueChanged<Message> callback);

  void addConnectStateChangeCallback(ValueChanged<bool> callback);

  void removeNicknamesChangeCallback(ValueChanged<List<String>> callback);

  void removeMessageReceiveCallback(ValueChanged<Message> callback);

  void removeConnectStateChangeCallback(ValueChanged<bool> callback);

  @mustCallSuper
  void dispose();
}
