import 'package:emojis/emoji.dart';
import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';

class EmojiPageView extends StatelessWidget {
  final ValueChanged<Emoji>? onTap;

  const EmojiPageView({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        itemCount: EmojiGroup.values.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          List<Emoji> emoji = Emoji.byGroup(EmojiGroup.values[index]).toList();
          return GridView.builder(
            itemCount: emoji.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  onTap?.call(emoji[index]);
                },
                child: Center(
                  child: Text(
                    emoji[index].char,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
