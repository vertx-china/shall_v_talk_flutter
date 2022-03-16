import 'package:shall_v_talk_flutter/base/base_change_notifier.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_client.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_websocket_client.dart';

class VTalkProvider extends BaseChangeNotifier{

  String nickname = '';

  VTalkClient? _client;

  VTalkClient get client {
    return _client ??= VTalkWebSocket();
  }

  Future<bool> connect(String host, String port, String nickname) async {
    final connectFuture = await client.connect(host, int.parse(port));
    this.nickname = nickname;
    print("-----------------$connectFuture");
    if (connectFuture) {
      client.login(nickname);
    }
    return connectFuture;
  }

  Future<void> reconnect() async {
    client.login(nickname);
  }



  @override
  void dispose() {
    client.dispose();
    super.dispose();
  }
}
