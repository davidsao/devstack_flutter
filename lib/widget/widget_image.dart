import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class AppImage extends StatelessWidget {
  final String image;
  final Widget? placeholder;
  final Color? color;
  final double? size;
  final BoxFit? fit;
  final BlendMode? blendMode;

  const AppImage(
    this.image, {
    super.key,
    this.placeholder,
    this.color,
    this.size,
    this.fit,
    this.blendMode,
  });

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      return placeholder ?? const SizedBox.shrink();
    }

    final lowerImage = image.toLowerCase();

    final isSvg = lowerImage.endsWith(".svg") ||
        (image.contains("svg") &&
            !image.contains(".png") &&
            !image.contains(".jpg"));
    final isJson = lowerImage.endsWith(".json");
    final isHttp = lowerImage.startsWith("http");

    if (isSvg) {
      if (isHttp) {
        return SvgPicture.network(
          image,
          width: size,
          height: size,
          fit: fit ?? BoxFit.contain,
          colorFilter: (color != null)
              ? ColorFilter.mode(
                  color!,
                  blendMode ?? BlendMode.srcIn,
                )
              : null,
        );
      } else {
        return SvgPicture.asset(
          image,
          fit: fit ?? BoxFit.contain,
          width: size,
          height: size,
          colorFilter: (color != null)
              ? ColorFilter.mode(
                  color!,
                  blendMode ?? BlendMode.srcIn,
                )
              : null,
        );
      }
    } else if (isJson) {
      if (isHttp) {
        return Lottie.network(
          image,
          width: size,
        );
      } else {
        return Lottie.asset(
          image,
          width: size,
        );
      }
    } else if (isHttp) {
      return CachedNetworkImage(
          fit: fit ?? BoxFit.cover,
          color: color,
          imageUrl: image,
          colorBlendMode:
              (color != null) ? (blendMode ?? BlendMode.srcIn) : null,
          width: size,
          height: size,
          placeholder: (context, url) =>
              (placeholder != null) ? placeholder! : const SizedBox.shrink(),
          errorWidget: (context, url, error) {
            return placeholder ?? const SizedBox.shrink();
          });
    } else {
      return Image.asset(
        image,
        fit: fit ?? BoxFit.cover,
        color: color,
        colorBlendMode: (color != null) ? (blendMode ?? BlendMode.srcIn) : null,
        width: size,
        height: size,
      );
    }
  }
}
