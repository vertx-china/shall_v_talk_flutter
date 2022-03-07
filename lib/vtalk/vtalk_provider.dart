import 'package:shall_v_talk_flutter/base/base_change_notifier.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_socket_client.dart';

class VTalkProvider extends BaseChangeNotifier{

  String nickname = '';

  Future<bool> connect(String host , String port, String nickname) async {
    var connectFuture = VTalkSocketClient.client.connect(host , int.parse(port));
    this.nickname = nickname;
    VTalkSocketClient.client.login(nickname);
    return connectFuture;
  }

  Future<void> reconnect() async {
    VTalkSocketClient.client.reconnect();
    VTalkSocketClient.client.login(nickname);
  }



  @override
  void dispose() {
    VTalkSocketClient.client.dispose();
    super.dispose();
  }

  void showConnectDialog() {

  }
}
