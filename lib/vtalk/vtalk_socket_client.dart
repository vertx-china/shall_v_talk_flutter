import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:shall_v_talk_flutter/model/message.dart';

class VTalkSocketClient {
  static late final VTalkSocketClient client = VTalkSocketClient._internal();

  final String _address = '103.145.87.185';
  final int _port = 32167;
  Socket? _socket;
  String? _socketId;

  final List<ValueChanged<List<String>>> _nicknamesChangeCallback = [];
  final List<ValueChanged<Message>> _messageReceiveCallback = [];

  VTalkSocketClient._internal();

  Future<void> connect() async {
    print('json==connect');
    _socket = await Socket.connect(
      _address,
      _port,
      timeout: const Duration(milliseconds: 3000),
    );
    _socket!.listen(_onMessageReceive);
  }

  void dispose() {
    _socket?.close();
    _socket = null;
  }

  void addNicknamesChangeCallback(ValueChanged<List<String>> callback) {
    _nicknamesChangeCallback.add(callback);
  }

  void addMessageReceiveCallback(ValueChanged<Message> callback) {
    _messageReceiveCallback.add(callback);
  }

  void sendMessage(String message) {
    Map<String, String> data = {
      'message': message,
    };
    _socket?.write(jsonEncode(data) + "\r\n");
  }

  void _onMessageReceive(Uint8List uint8list) {
    var json = utf8.decode(uint8list);
    print('json==$json');
    Map<String, dynamic> map = jsonDecode(json);
    if (map['id'] != null && map.length == 1) {
      _socketId = map['id'];
    } else if (map['nicknames'] != null && map.length == 1) {
      List<String> nicknames =
          (map['nicknames'] as List).map((e) => e.toString()).toList();
      _notifyNicknamesChange(nicknames);
    } else {
      var message = Message.fromJson(map);
      _notifyMessageReceive(message);
    }
  }

  void _notifyNicknamesChange(List<String> nicknames) {
    for (var element in _nicknamesChangeCallback) {
      element.call(nicknames);
    }
  }

  void _notifyMessageReceive(Message message) {
    for (var element in _messageReceiveCallback) {
      element.call(message);
    }
  }
}
