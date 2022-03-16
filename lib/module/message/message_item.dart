import 'package:flutter/material.dart';
import 'package:shall_v_talk_flutter/extension/extension_index.dart';
import 'package:shall_v_talk_flutter/model/message.dart';
import 'package:shall_v_talk_flutter/module/message/picture_page.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageItem extends StatelessWidget {
  final Message message;

  const MessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isLocal ? Alignment.topRight : Alignment.topLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            message.isLocal ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
          //服务端是这么定的。。。实际上message应该不太可能包含多个消息?
          message.message is List
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
                ),
        ],
      ),
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
      String type = message['type']?.toString() ?? '0';
      //只支持url
      if (type == 'img' && message['img'] != null) {
        child = _ImageUrlContent(url: message['img']);
      } else if (type == 'link') {
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
