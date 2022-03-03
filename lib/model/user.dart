class User {
  String? nickname;

  User({
    this.nickname,
  });

  User.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nickname'] = nickname;
    return data;
  }


}
