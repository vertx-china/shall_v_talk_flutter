# shall_v_talk_flutter

## 设计
* 本地数据存储考虑使用[sqflite_common_ffi](https://pub.flutter-io.cn/packages/sqflite_common_ffi)或者[objectbox](https://pub.flutter-io.cn/packages/objectbox)。为了充分发挥flutter跨平台优势，第三方插件尽量考虑支持Window/Macos/Linux平台。
* 消息存储。不能在局部Provider中处理（MessageProvider）。需要考虑到若MessagePage并非Page栈栈底元素的情况。考虑单一数据源的设计，将消息接收，存储提升到全局Provider中处理（例如VTalkProvider）。
* 平台特性：桌面版消息页增加在线成员展示/支持拖动图片到输入框/聊天图片点击查看大图，弹出桌面端对应图片应用窗口查看大图