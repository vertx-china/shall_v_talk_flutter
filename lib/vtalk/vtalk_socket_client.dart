import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:shall_v_talk_flutter/model/message.dart';

class VTalkSocketClient {
  static late final VTalkSocketClient client = VTalkSocketClient._internal();

  Socket? _socket;
  String? _socketId;
  bool connecting = false;

  String? get socketId => _socketId;

  final List<ValueChanged<List<String>>> _nicknamesChangeCallback = [];
  final List<ValueChanged<Message>> _messageReceiveCallback = [];

  VTalkSocketClient._internal();

  Future<void> connect(String host, int port) async {
    _socket = await Socket.connect(
      host,
      port,
      timeout: const Duration(milliseconds: 3000),
    );
    connecting = true;
    _socket!.listen(
      _onMessageReceive,
      onDone: _onConnectDone,
    );
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

  Message sendMessage(String message) {
    Map<String, String> data = {
      'message': message,
    };
    _socket?.write(jsonEncode(data) + "\r\n");
    return Message(
      id: _socketId,
      message: message,
      time: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  void _onMessageReceive(Uint8List uint8list) {
    var json = utf8.decode(uint8list);
    List<String> messages = json.split("\r\n");
    print('messages=$messages');
    for (var element in messages) {
      print('json=$element');
      try {
        Map<String, dynamic> map = jsonDecode(element);
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
      } catch (e) {

      }
    }
  }

  void _onConnectDone() {
    connecting = false;
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

  void login(String nickname) {
    Map<String, String> data = {
      'nickname': nickname,
    };
    _socket?.write(jsonEncode(data) + "\r\n");
  }
}
