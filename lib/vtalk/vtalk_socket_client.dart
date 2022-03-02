import 'dart:io';

class VTalkSocketClient {
  static late final VTalkSocketClient client = VTalkSocketClient._internal();

  final String _address = '103.145.87.185';
  final int _port = 32167;
  Socket? _socket;

  VTalkSocketClient._internal();


  Future<void> connect() async {
    print('login');
    _socket = await Socket.connect(
      _address,
      _port,
      timeout: const Duration(milliseconds: 3000),
    );
    _socket!.listen((event) {
      print('connect, data=${String.fromCharCodes(event)}');
    });
  }

  void dispose(){
    _socket?.close();
    _socket = null;
  }

}
