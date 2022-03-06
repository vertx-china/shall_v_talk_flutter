import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/model/message.dart';
import 'package:shall_v_talk_flutter/module/message/emoji_page_view.dart';
import 'package:shall_v_talk_flutter/module/message/message_item.dart';
import 'package:shall_v_talk_flutter/module/message/message_provider.dart';
import 'package:shall_v_talk_flutter/utils/pair.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_provider.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => MessageProvider(context),
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Selector<MessageProvider, bool>(
                selector: (_, provider) => provider.connected,
                shouldRebuild: (pre, curr) => pre != curr,
                builder: (context, connecting, child) {
                  return Visibility(
                    visible: !connecting,
                    child: GestureDetector(
                      onTap: () {
                        context.read<VTalkProvider>().reconnect();
                      },
                      child: Container(
                        color: Colors.redAccent.withAlpha(128),
                        constraints: const BoxConstraints(
                          minWidth: double.infinity,
                          maxWidth: double.infinity,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        child: const Text('你已经断开链接'),
                      ),
                    ),
                  );
                }),
            Expanded(
              child: Selector<MessageProvider, List<Message>>(
                selector: (_, provider) => provider.messages,
                shouldRebuild: (pre, curr) => true,
                builder: (context, messages, child) {
                  return ListView.separated(
                    reverse: true,
                    controller:
                        context.read<MessageProvider>().scrollController,
                    itemCount: messages.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    itemBuilder: (context, index) {
                      Message message = messages[index];
                      bool seconded = false;
                      if (messages.length > 2 &&
                          index == messages.length - 1 &&
                          !message.isLocal) {
                        Message preMessage = messages[index - 1];
                        Message preMessage2 = messages[index - 2];
                        dynamic m1 = message.message;
                        dynamic m2 = preMessage.message;
                        seconded = preMessage2.id != preMessage.id &&
                            m1 is String &&
                            m1 == m2;
                      }
                      Widget child = MessageItem(message: message);
                      if (seconded) {
                        child = Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            child,
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<MessageProvider>()
                                    .sendMessage(message.message);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                width: 20,
                                height: 20,
                                child: Center(
                                  child: Text(
                                    '+1',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 12,
                                      height: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return child;
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16);
                    },
                  );
                },
              ),
            ),
            const _InputBar(),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.read<MessageProvider>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: StadiumBorder(),
                  ),
                  child: TextField(
                    controller: provider.textEditingController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: () {
                  var message = provider.textEditingController.text;
                  provider.sendMessage(message);
                },
                child: Container(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: const StadiumBorder(),
                  ),
                  child: const Center(
                    child: Text(
                      '发送',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  height: 45,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        const _EmojiPanel(),
      ],
    );
  }
}

class _EmojiPanel extends StatelessWidget {
  const _EmojiPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.read<MessageProvider>();
    return Selector<MessageProvider, Pair<int ,List<IconData>>>(
      selector: (_, provider) => Pair(provider.displayPanelIndex , provider.extendPanel),
      shouldRebuild: (pre, curr) => pre != curr,
      builder: (context, pair, child) {
        int displayIndex = pair.first;
        List<IconData> icons = pair.second;
        return Column(
          children: [
            SizedBox(
              height: 30,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: icons.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      provider.changePanelVisibleState(index);
                    },
                    child: Icon(
                      icons[index],
                      color: Colors.grey,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: displayIndex >= 0 && displayIndex < icons.length,
              child: IndexedStack(
                index: displayIndex,
                children: [
                  EmojiPageView(
                    onTap: provider.appendEmoji,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
