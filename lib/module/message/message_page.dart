import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/model/message.dart';
import 'package:shall_v_talk_flutter/module/message/message_item.dart';
import 'package:shall_v_talk_flutter/module/message/message_provider.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => MessageProvider(context),
      child: Scaffold(
        appBar: AppBar(
          actions: [],
        ),
        body: Column(
          children: [
            Expanded(
              child: Selector<MessageProvider, List<Message>>(
                selector: (_, provider) => provider.messages,
                shouldRebuild: (pre, curr) => true,
                builder: (context, messages, child) {
                  return ListView.separated(
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
            Builder(
              builder: (context) {
                var provider = context.read<MessageProvider>();
                return Padding(
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
                            textInputAction: TextInputAction.send,
                            controller: provider.textEditingController,
                            onSubmitted: provider.sendMessage,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                )),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
