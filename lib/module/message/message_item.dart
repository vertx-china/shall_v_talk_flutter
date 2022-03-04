import 'package:flutter/material.dart';
import 'package:shall_v_talk_flutter/model/message.dart';

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
          Container(
            margin: const EdgeInsets.only(
              top: 4,
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              color:
                  (message.isLocal ? Colors.cyan : Colors.green).withAlpha(128),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 12,
            ),
            child: Text(
              message.message ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
