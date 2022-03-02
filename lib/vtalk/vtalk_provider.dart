import 'package:shall_v_talk_flutter/base/base_change_notifier.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_socket_client.dart';

class VTalkProvider extends BaseChangeNotifier {
  VTalkProvider() {
    _connect();
  }

  void _connect() {
    VTalkSocketClient.client.connect();
  }

  @override
  void dispose() {
    VTalkSocketClient.client.dispose();
    super.dispose();
  }
}
