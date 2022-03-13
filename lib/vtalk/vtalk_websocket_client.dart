import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:shall_v_talk_flutter/model/message.dart';
import 'package:web_socket_channel/io.dart';

class VTalkWebSocket{

  static late final VTalkWebSocket client = VTalkWebSocket._internal();

  VTalkWebSocket._internal();

  String? host;
  int? port;
  String? _socketId;
  IOWebSocketChannel? channel;
  String nickname = '';
  bool connected = false;

  String? get socketId => _socketId;

  final List<ValueChanged<List<String>>> _nicknamesChangeCallback = [];
  final List<ValueChanged<Message>> _messageReceiveCallback = [];
  final List<ValueChanged<bool>> _connectStateChangeCallback = [];


  bool isConnecting = false;
  Future connect(String host, int port) async {
    if(isConnecting){
      return false;
    }
    isConnecting = true;
    this.host = host;
    this.port = port;
    final completer = Completer.sync();
    try{
      channel = IOWebSocketChannel.connect("ws://$host:$port",
          pingInterval: const Duration(seconds: 10));
      channel?.stream.listen((msg) {
        _onMessageReceive(msg);
      });
      _updateConnectState(true);
      isConnecting = false;
      completer.complete(true);
    }catch(e){
      print('链接错误');
      completer.completeError(false);
    }
    isConnecting = false;
    return completer.future;
  }

  void _onMessageReceive(String msg) {
    print('---------------------$msg');
    // var json = utf8.decode(msg);
    List<String> messages = msg.split("\r\n");
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
      } catch (e) {}
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
  void _notifyConnectStateChange(bool connectState) {
    for (var element in _connectStateChangeCallback) {
      element.call(connectState);
    }
  }

  void addNicknamesChangeCallback(ValueChanged<List<String>> callback) {
    _nicknamesChangeCallback.add(callback);
  }

  void addMessageReceiveCallback(ValueChanged<Message> callback) {
    _messageReceiveCallback.add(callback);
  }
  void addConnectStateChangeCallback(ValueChanged<bool> callback) {
    _connectStateChangeCallback.add(callback);
    callback.call(connected);
  }

  void _updateConnectState(bool connected){
    this.connected = connected;
    print('connected==$connected');
    _notifyConnectStateChange(connected);
  }

  void _write(String data) {
    channel?.sink.add(data + "\r\n");
  }

  Message sendMessage(String message) {
    Map<String, String> data = {
      'message': message,
    };
    _write(jsonEncode(data));

    var now = DateTime.now();
    return Message(
      id: _socketId,
      message: message,
      timestamp: now.millisecondsSinceEpoch,
      time: formatDate(now, [
        'yyyy',
        '-',
        'mm',
        '-',
        'dd',
        ' ',
        'hh',
        ':',
        'nn',
        ':',
        'ss',
        ' ',
        'z'
      ]),
      isLocal: true,
    );
  }

  void login(String nickname) {
    this.nickname = nickname;
    Map<String, String> data = {
      'nickname': nickname,
    };
    _write(jsonEncode(data));
  }

  void dispose() {
    channel?.sink.close();
    channel = null;
  }

}