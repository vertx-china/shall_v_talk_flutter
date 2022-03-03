import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/model/message.dart';
import 'package:shall_v_talk_flutter/module/message/message_provider.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_provider.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => MessageProvider(context),
      child: Scaffold(
        appBar: AppBar(
          actions: [

          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Selector<MessageProvider, List<Message>>(
                selector: (_, provider) => provider.messages,
                shouldRebuild: (pre, curr) => true,
                builder: (context, messages, child) {
                  return ListView.builder(
                    itemCount: messages.length,
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
              var provider = context.read<MessageProvider>();
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 18,
                ),
                child: TextField(
                  textInputAction: TextInputAction.send,
                  controller: provider.textEditingController,
                  onSubmitted: provider.sendMessage,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
