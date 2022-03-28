# shall_v_talk_flutter

## 设计

*
本地数据存储考虑使用[sqflite_common_ffi](https://pub.flutter-io.cn/packages/sqflite_common_ffi)或者[objectbox](https://pub.flutter-io.cn/packages/objectbox)。为了充分发挥flutter跨平台优势，第三方插件尽量考虑支持Window/Macos/Linux平台。
*
消息存储。不能在局部Provider中处理（MessageProvider）。需要考虑到若MessagePage并非Page栈栈底元素的情况。考虑单一数据源的设计，将消息接收，存储提升到全局Provider中处理（例如VTalkProvider）。
