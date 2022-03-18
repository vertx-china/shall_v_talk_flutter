class MessageEnum {
  static const MessageEnum text = MessageEnum._internal([0, 'txt', 'text']);
  static const MessageEnum image = MessageEnum._internal([1, 'img', 'image']);
  static const MessageEnum link =
      MessageEnum._internal([2, 'link', 'url', 'hyperlink']);
  static const MessageEnum history = MessageEnum._internal([3, 'history']);
  static const MessageEnum video = MessageEnum._internal([4, 'video']);
  static const MessageEnum audio = MessageEnum._internal([5, 'audio']);

  final List<dynamic> _value;

  List<dynamic> get value => _value;

  const MessageEnum._internal(this._value);

  static bool isText(dynamic type) => text.value.contains(type);

  static bool isImage(dynamic type) => image.value.contains(type);

  static bool isLink(dynamic type) => link.value.contains(type);

  static bool isHistory(dynamic type) => history.value.contains(type);

  static bool isVideo(dynamic type) => video.value.contains(type);

  static bool isAudio(dynamic type) => audio.value.contains(type);
}
