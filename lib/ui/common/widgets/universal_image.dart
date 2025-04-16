import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as path;

class UniversalImage extends StatelessWidget {
  const UniversalImage(
    this.imagePath, {
    super.key,
    required this.width,
    required this.height,
    required this.fit,
  });

  final String? imagePath;
  final double width;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final imagePath = this.imagePath;

    if (imagePath == null) {
      return SizedBox(width: width, height: height);
    } else if (imagePath.startsWith('https')) {
      if (path.extension(imagePath) == '.svg' || imagePath.contains('/svg')) {
        return SvgPicture.network(
          imagePath,
          width: width,
          height: height,
          fit: fit,
        );
      } else {
        return CachedNetworkImage(
          imageUrl: imagePath,
          width: width,
          height: height,
          fit: fit,
        );
      }
    } else if (imagePath.startsWith('assets')) {
      if (path.extension(imagePath) == '.svg') {
        return SvgPicture.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
        );
      } else {
        return Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
        );
      }
    } else {
      return Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: fit,
      );
    }
  }
}
