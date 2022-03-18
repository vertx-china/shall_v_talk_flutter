import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:shall_v_talk_flutter/model/message.dart';
import 'package:shall_v_talk_flutter/vtalk/message_enum.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_client.dart';

class VTalkSocketClient extends VTalkClient {
  Socket? _socket;
  String? _socketId;
  String nickname = '';
  String? host;
  int? port;

  Timer? timer;
  int commandTime = 15;
  bool connected = false;

  void _updateConnectState(bool connected) {
    this.connected = connected;
    print('connected==$connected');
    _notifyConnectStateChange(connected);
  }

  String? get socketId => _socketId;

  final List<ValueChanged<List<String>>> _nicknamesChangeCallback = [];
  final List<ValueChanged<Message>> _messageReceiveCallback = [];
  final List<ValueChanged<bool>> _connectStateChangeCallback = [];

  bool isConnecting = false;

  @override
  Future<bool> connect(String host, int port) async {
    if (isConnecting) {
      return false;
    }
    isConnecting = true;
    this.host = host;
    this.port = port;
    _socket = await Socket.connect(
      host,
      port,
      timeout: const Duration(milliseconds: 3000),
    );
    _updateConnectState(true);
    _socket?.listen(_onMessageReceive, onDone: _onConnectDone);
    isConnecting = false;
    return _socket != null;
  }

  void reconnect() {
    int count = 0;
    const period = Duration(seconds: 1);
    Timer.periodic(
      period,
      (timer) {
        _socketId = null;
        _socket = null;
        count++;
        if (count >= 3) {
          connect(host!, port!);
          timer.cancel();
          count = 0;
        }
      },
    );
  }

  void _heartBeat() {
    var duration = const Duration(seconds: 1);
    timer = Timer.periodic(duration, (Timer timer) async {
      var result = await Connectivity().checkConnectivity();
      if (result != ConnectivityResult.mobile &&
          result != ConnectivityResult.wifi) {
        _updateConnectState(false);
        timer.cancel();
      } else {
        _updateConnectState(true);
      }

      if (commandTime < 1) {
        commandTime = 15;
        _write('');
      } else {
        commandTime--;
      }
    });
  }

  @override
  void dispose() {
    _socket?.close();
    _socket = null;
  }

  @override
  void addNicknamesChangeCallback(ValueChanged<List<String>> callback) {
    _nicknamesChangeCallback.add(callback);
  }

  @override
  void addMessageReceiveCallback(ValueChanged<Message> callback) {
    _messageReceiveCallback.add(callback);
  }

  @override
  void addConnectStateChangeCallback(ValueChanged<bool> callback) {
    _connectStateChangeCallback.add(callback);
    callback.call(connected);
  }

  @override
  void removeNicknamesChangeCallback(ValueChanged<List<String>> callback) {
    _nicknamesChangeCallback.remove(callback);
  }

  @override
  void removeMessageReceiveCallback(ValueChanged<Message> callback) {
    _messageReceiveCallback.remove(callback);
  }

  @override
  void removeConnectStateChangeCallback(ValueChanged<bool> callback) {
    _connectStateChangeCallback.remove(callback);
  }

  void _write(String data) {
    _socket?.write(data + "\r\n");
  }

  @override
  Message sendTextMessage(String message) {
    Map<String, dynamic> data = {
      'message': {
        "type": MessageEnum.text.value.first,
        "content": message,
      },
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
          //_heartBeat();
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

  void _onConnectDone() {
    print('_onConnectDone');
    _updateConnectState(false);
    reconnect();
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

  @override
  void login(String nickname) {
    this.nickname = nickname;
    Map<String, String> data = {
      'nickname': nickname,
    };
    _write(jsonEncode(data));
  }
}
