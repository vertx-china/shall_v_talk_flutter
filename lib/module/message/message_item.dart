import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shall_v_talk_flutter/model/message.dart';
import 'package:shall_v_talk_flutter/extension/stringx.dart';

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
    } else if(message is Map){
      String type = message['type']?.toString() ?? '0';
      //只支持url
      if(type == 'img' && message['img'] != null){
        child = _ImageUrlContent(url: message['img']);
      }else if(type == 'link'){
        //Todo
        child = _TextContent(text: message?.toString() ?? '');
      }else{
        child = _TextContent(text: message?.toString() ?? '');
      }
    }else {
      child = _TextContent(text: message?.toString() ?? '');
    }
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ),
        color: (isLocal ? Colors.blue : Colors.green).withAlpha(128),
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
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
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 200,
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Image.network(
          url,
          alignment: Alignment.topCenter,
          cacheWidth: (MediaQuery.of(context).size.width * 0.7).toInt(),
        ),
      ),
    );
  }
}
