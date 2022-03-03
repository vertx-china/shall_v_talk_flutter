class User {
  String? id;
  String? nickname;

  User({
    this.id,
    this.nickname,
  });

  User.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nickname'] = nickname;
    data['id'] = id;
    return data;
  }


}
