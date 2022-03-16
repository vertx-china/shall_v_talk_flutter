class MessageEnum {
  static const MessageEnum text = MessageEnum._internal(0);
  static const MessageEnum image = MessageEnum._internal('img');
  static const MessageEnum link = MessageEnum._internal('link');
  static const MessageEnum history = MessageEnum._internal('history');
  static const MessageEnum video = MessageEnum._internal('video');
  static const MessageEnum audio = MessageEnum._internal('audio');

  final dynamic _value;

  dynamic get value => _value;

  const MessageEnum._internal(this._value);
}
