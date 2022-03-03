import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shall_v_talk_flutter/module/login/login_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => LoginProvider(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            children: [
              Expanded(
                child: SvgPicture.asset('assets/images/logo.svg'),
              ),
              const _InternetAddressInput(),
              const SizedBox(
                height: 16,
              ),
              const _NicknameInput(),
              const SizedBox(
                height: 32,
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    return MaterialButton(
                      child: const Icon(
                        Icons.login,
                        color: Colors.white,
                        size: 35,
                      ),
                      color: Theme.of(context).primaryColor,
                      shape: const CircleBorder(),
                      height: 80,
                      onPressed: context.read<LoginProvider>().login,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InternetAddressInput extends StatelessWidget {
  const _InternetAddressInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: context.read<LoginProvider>().internetAddressController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'IP地址(127.0.0.1:5555)',
        hintText: '输入IP地址：如127.0.0.1:5555',
      ),
      maxLines: 1,
    );
  }
}

class _NicknameInput extends StatelessWidget {
  const _NicknameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: context.read<LoginProvider>().nicknameController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '昵称',
        hintText: '输入昵称',
      ),
      maxLines: 1,
    );
  }
}
