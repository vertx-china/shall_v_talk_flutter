class Message {
  String? id;
  dynamic message;
  String? color;
  String? nickname;
  String? time;
  int? timestamp;
  late bool isLocal;

  Message({
    this.id,
    this.message,
    this.color,
    this.nickname,
    this.time,
    this.timestamp,
    this.isLocal = false,
  });

  Message.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    color = json['color'];
    nickname = json['nickname'];
    id = json['id'];
    time = json['time'];
    timestamp = json['timestamp'];
    isLocal = false;
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
