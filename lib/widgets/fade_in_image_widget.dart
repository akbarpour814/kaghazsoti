import 'package:flutter/material.dart';

import '../main.dart';

class FadeInImageWidget extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;

  const FadeInImageWidget({
    Key? key,
    required this.image,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: defaultBookCover,
      placeholderErrorBuilder: (context, object, stackTrace) {
        return Text('placeholderErrorBuilder');
      },
      image: image,
      imageErrorBuilder: (context, object, stackTrace) {
        return Text('imageErrorBuilder');
      },
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
