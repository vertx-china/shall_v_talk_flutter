import 'package:emojis/emoji.dart';
import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/base/base_change_notifier.dart';
import 'package:shall_v_talk_flutter/model/message.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_provider.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_socket_client.dart';

class MessageProvider extends BaseChangeNotifier {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<Message> messages = [];
  final BuildContext context;
  bool connected = false;

  final List<IconData> extendPanel = [
    Icons.emoji_emotions_rounded,
  ];
  int displayPanelIndex = -1;

  MessageProvider(this.context) {
    _initCallback();
  }

  void _initCallback() {
    VTalkSocketClient.client.addMessageReceiveCallback(_onMessageReceive);
    VTalkSocketClient.client.addConnectStateChangeCallback(_onConnectStateChange);
  }

  void _onMessageReceive(Message message) {
    messages.insert(0 , message);
    notifyListeners();
  }

  void _onConnectStateChange(bool connected){
    this.connected = connected;
    notifyListeners();
  }

  void appendEmoji(Emoji emoji){
    textEditingController.text = textEditingController.text + emoji.char;
  }

  Future<void> sendMessage(String message) async {
    scrollController.jumpTo(0.0);
    var vTalkProvider = context.read<VTalkProvider>();
    var nickname = vTalkProvider.nickname;
    textEditingController.clear();
    String assembled = Emoji.assemble([Emojis.man, Emojis.man, Emojis.girl, Emojis.boy]);
    Message data = VTalkSocketClient.client.sendMessage(message);
    data.nickname = nickname;
    messages.insert(0, data);
    notifyListeners();
  }

  void changePanelVisibleState(int index) {
    if(displayPanelIndex == index){
      displayPanelIndex = -1;
    }else{
      displayPanelIndex = index;
    }
    notifyListeners();
  }
}
