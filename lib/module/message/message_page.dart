import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/model/message.dart';
import 'package:shall_v_talk_flutter/module/message/message_provider.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => MessageProvider(),
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: Selector<MessageProvider, List<Message>>(
                selector: (_, provider) => provider.messages,
                shouldRebuild: (pre, curr) => true,
                builder: (context, messages, child) {
                  return ListView.builder(
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      Message message = messages[index];
                      return ListTile(
                        title: Text(message.nickname!),
                        subtitle: Text(message.message!),
                      );
                    },
                  );
                },
              ),
            ),
            Builder(builder: (context) {
              return TextField(
                textInputAction: TextInputAction.send,
                controller:
                    context.read<MessageProvider>().textEditingController,
                onSubmitted: (text) {
                  context.read<MessageProvider>().sendMessage(text);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
