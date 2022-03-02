import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/vtalk/vtalk_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VTalkProvider vTalkProvider = context.read<VTalkProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 48
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _NicknameInput(),
            const SizedBox(
              height: 32,
            ),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              shape: const CircleBorder(),
              height: 80,
              onPressed: (){

              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NicknameInput extends StatelessWidget {
  const _NicknameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        hintText: '输入昵称',
        hintStyle: TextStyle(
          fontSize: 14,
          color: Color(0x61000000),
        ),
      ),
    );
  }
}

