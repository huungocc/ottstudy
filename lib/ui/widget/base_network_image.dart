import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'widget.dart';

class BaseNetworkImage extends StatelessWidget {
  final String? url;
  final double borderRadius;
  final double? width;
  final double? height;
  final String? errorAssetImage;
  final double? loadingSize;
  final BoxFit? boxFit;

  const BaseNetworkImage(
      {Key? key,
        this.url,
        this.borderRadius = 0,
        this.width,
        this.height,
        this.errorAssetImage,
        this.loadingSize,
        this.boxFit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget errorWidget = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 10),
      child: Container(
        width: this.width ?? double.infinity,
        height: this.height,
        child: errorAssetImage?.isNotEmpty ?? false
            ? Image.asset(
          errorAssetImage!,
          width: this.width,
          height: this.height,
          fit: BoxFit.cover,
        )
        // : Icon(Icons.error),
            : Container(
          color: Color(0xffe6e8eb),
          child: Center(child: Icon(Icons.error_outline_rounded),)
        ),
      ),
    );
    return url == null
        ? errorWidget
        : ClipRRect(
      child: CachedNetworkImage(
        width: this.width,
        height: this.height,
        fit: boxFit ?? BoxFit.contain,
        imageUrl: url ?? '',
        placeholder: (context, url) => Center(
          child: BaseProgressIndicator(size: loadingSize ?? 10),
        ),
        // errorWidget: (context, url, error) => errorWidget,
        errorWidget: (context, url, error) => Center(child: Icon(Icons.error_outline_rounded),),
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}
