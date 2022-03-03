import 'package:flutter/material.dart';

class LoginDialog extends StatefulWidget {


  const LoginDialog({
    Key? key,
  }) :super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {

  String nickname = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '昵称',
                ),
                onChanged: (value){
                  nickname = value;
                },
                maxLines: 1,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop(nickname);
                },
                child: const Text('提交'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
