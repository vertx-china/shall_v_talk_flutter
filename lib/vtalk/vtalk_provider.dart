import 'package:shall_v_talk_flutter/base/base_change_notifier.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_socket_client.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_websocket_client.dart';

class VTalkProvider extends BaseChangeNotifier{

  String nickname = '';

  Future<bool> connect(String host , String port, String nickname) async {
    final connectFuture = await VTalkWebSocket.client.connect(host , int.parse(port));
    this.nickname = nickname;
    print("-----------------$connectFuture");
    if(connectFuture){
      VTalkWebSocket.client.login(nickname);
    }
    return connectFuture;
  }

  Future<void> reconnect() async {
    // VTalkWebSocket.client.reconnect();
    VTalkWebSocket.client.login(nickname);
  }



  @override
  void dispose() {
    VTalkWebSocket.client.dispose();
    super.dispose();
  }

  void showConnectDialog() {

  }
}
