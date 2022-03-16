import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PicturePage extends StatelessWidget {
  final String url;

  const PicturePage({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white.withAlpha(128),
          ),
        ),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(url),
        maxScale: 3.0,
        minScale: 0.5,
      ),
    );
  }
}
