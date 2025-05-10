import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'widget.dart';

class BaseNetworkImage extends StatelessWidget {
  final String? url;
  final double borderRadius;
  final double? width;
  final double? height;
  final double? loadingSize;
  final BoxFit? boxFit;
  final bool? isFromDatabase;
  final Widget? errorBuilder;

  const BaseNetworkImage({
    Key? key,
    this.url,
    this.borderRadius = 0,
    this.width,
    this.height,
    this.loadingSize,
    this.boxFit,
    this.isFromDatabase = false,
    this.errorBuilder,
  }) : super(key: key);

  String trimTrailingSlash(String input) {
    return input.endsWith('/') ? input.substring(0, input.length - 1) : input;
  }

  @override
  Widget build(BuildContext context) {
    Widget defaultErrorWidget = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width ?? double.infinity,
        height: height,
        color: const Color(0xffe6e8eb),
        child: const Center(
          child: Icon(Icons.error_outline_rounded),
        ),
      ),
    );

    if (url == null || url!.isEmpty) {
      return errorBuilder ?? defaultErrorWidget;
    }

    String imageUrl = isFromDatabase == true
        ? '${trimTrailingSlash(dotenv.env['API_URL'] ?? '')}$url'
        : url!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        width: width,
        height: height,
        fit: boxFit ?? BoxFit.contain,
        imageUrl: imageUrl,
        placeholder: (context, url) => Center(
          child: BaseProgressIndicator(size: loadingSize ?? 10),
        ),
        errorWidget: (context, url, error) => errorBuilder ?? defaultErrorWidget,
      ),
    );
  }
}