import 'package:date_format/date_format.dart';

class Message {
  String? id;
  dynamic message;
  String? color;
  String? nickname;
  String? time;
  int? timestamp;
  late bool isLocal;
  String? formatTime;

  Message({
    this.id,
    this.message,
    this.color,
    this.nickname,
    this.time,
    this.timestamp,
    this.isLocal = false,
    this.formatTime = ''
  });

  Message.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    color = json['color'];
    nickname = json['nickname'];
    id = json['id'];
    time = json['time'];
    timestamp = json['timestamp'];
    isLocal = false;
    var dateTime = DateTime.tryParse(time??"");
    formatTime = "${dateTime?.month}-${dateTime?.day} ${dateTime?.hour}:${dateTime?.minute}";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['color'] = color;
    data['nickname'] = nickname;
    data['id'] = id;
    data['time'] = time;
    data['timestamp'] = timestamp;
    return data;
  }

  bool isSelf() => isLocal;
}
