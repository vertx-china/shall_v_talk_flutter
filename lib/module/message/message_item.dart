import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/extension/extension_index.dart';
import 'package:shall_v_talk_flutter/model/message.dart';
import 'package:shall_v_talk_flutter/module/message/picture_page.dart';
import 'package:shall_v_talk_flutter/module/message/provider/message_provider.dart';
import 'package:shall_v_talk_flutter/vtalk/message_enum.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  final bool seconded;

  const MessageItem({
    Key? key,
    required this.message,
    this.seconded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = message.message is List
        ? Column(
      mainAxisSize: MainAxisSize.min,
      children: (message.message as List)
          .map(
            (e) => _MessageContent(
          message: e,
          isLocal: message.isLocal,
        ),
      )
          .toList(),
    )
        : _MessageContent(
      message: message.message,
      isLocal: message.isLocal,
    );

    if (message.isLocal) {
      return _SelfContainer(
        message: message,
        child: child,
      );
    } else {
      return _OtherContainer(
        message: message,
        child: child,
      );
    }
  }
}

class _SelfContainer extends StatelessWidget {
  final Message message;
  final Widget child;

  const _SelfContainer({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.nickname ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            child,
          ],
        ),
        const SizedBox(width: 8),
        _UserAvatar(name: message.nickname ?? ' '),
      ],
    );
  }
}

class _OtherContainer extends StatelessWidget {
  final Message message;
  final Widget child;
  final bool seconded;

  const _OtherContainer({
    Key? key,
    required this.message,
    required this.child,
    this.seconded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = child;
    if (seconded) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          child,
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              context.read<MessageProvider>().sendMessage(message.message);
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UserAvatar(name: message.nickname ?? ' '),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.nickname ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            content,
          ],
        ),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String name;

  const _UserAvatar({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      child: SizedBox(
        width: 20,
        height: 20,
        child: Center(
          child: Text(
            name.substring(0, 1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.lightBlueAccent.withAlpha(126),
    );
  }
}

class _MessageContent extends StatelessWidget {
  final dynamic message;
  final bool isLocal;

  const _MessageContent({
    Key? key,
    required this.message,
    required this.isLocal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (message is String && (message as String).isPhotoUrl()) {
      child = _ImageUrlContent(url: message);
    } else if (message is Map) {
      dynamic type = message['type'] ?? 0;
      if(MessageEnum.isText(type)){
        child = _TextContent(text: message['content']);
      }else if (MessageEnum.isImage(type) && message['url'] != null) {
        child = _ImageUrlContent(url: message['url']);
      } else if (MessageEnum.isImage(type) && message['base64'] != null) {
        List<String> captchaCode = message['base64'].split(',');
        String base64 =
            captchaCode.length > 1 ? captchaCode[1] : captchaCode[0];
        child = _ImageBase64Content(base64: base64);
      } else if (MessageEnum.isLink(type)) {
        child = _TextContent(text: message['url']?.toString() ?? '');
      } else {
        child = _TextContent(text: message?.toString() ?? '');
      }
    } else {
      child = _TextContent(text: message?.toString() ?? '');
    }
    return Container(
      constraints: BoxConstraints(
        maxWidth: 0.7.widthPercent(context),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isLocal ? 6 : 2),
          topRight: Radius.circular(isLocal ? 2 : 6),
          bottomLeft: const Radius.circular(6),
          bottomRight: const Radius.circular(6),
        ),
        color: (isLocal ? Colors.blue : Colors.green).withAlpha(80),
      ),
      child: child,
    );
  }
}

class _TextContent extends StatelessWidget {
  final String text;

  const _TextContent({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var child = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      child: GestureDetector(
        onTap: () {
          if (text.isUrl()) {
            launch(text);
          }
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: text.isUrl() ? Colors.blue : Colors.black,
            decoration: text.isUrl() ? TextDecoration.underline : null,
          ),
        ),
      ),
    );

    return child;
  }
}

class _ImageUrlContent extends StatelessWidget {
  final String url;

  const _ImageUrlContent({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 6,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (c) => PicturePage(url: url),
            ),
          );
        },
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 200,
            maxWidth: 0.7.widthPercent(context),
          ),
          child: Image.network(
            url,
            alignment: Alignment.topCenter,
            cacheWidth: 0.7.widthPercent(context).toInt(),
          ),
        ),
      ),
    );
  }
}

class _ImageBase64Content extends StatelessWidget {
  final String base64;

  const _ImageBase64Content({
    Key? key,
    required this.base64,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 6,
      ),
      child: GestureDetector(
        onTap: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (c) => PicturePage(url: url),
          //   ),
          // );
        },
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 200,
            maxWidth: 0.7.widthPercent(context),
          ),
          child: Image.memory(
            const Base64Decoder().convert(base64),
            alignment: Alignment.topCenter,
            cacheWidth: 0.7.widthPercent(context).toInt(),
          ),
        ),
      ),
    );
  }
}
