/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsFilesGen {
  const $AssetsFilesGen();

  /// File path: assets/files/pdf_test.pdf
  String get pdfTest => 'assets/files/pdf_test.pdf';

  /// List of all assets
  List<String> get values => [pdfTest];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app_bar_background.png
  AssetGenImage get appBarBackground =>
      const AssetGenImage('assets/images/app_bar_background.png');

  /// File path: assets/images/ic_back.png
  AssetGenImage get icBack => const AssetGenImage('assets/images/ic_back.png');

  /// File path: assets/images/ic_brain_white.png
  AssetGenImage get icBrainWhite =>
      const AssetGenImage('assets/images/ic_brain_white.png');

  /// File path: assets/images/ic_clock.png
  AssetGenImage get icClock =>
      const AssetGenImage('assets/images/ic_clock.png');

  /// File path: assets/images/ic_clock_white.png
  AssetGenImage get icClockWhite =>
      const AssetGenImage('assets/images/ic_clock_white.png');

  /// File path: assets/images/ic_explorer.png
  AssetGenImage get icExplorer =>
      const AssetGenImage('assets/images/ic_explorer.png');

  /// File path: assets/images/ic_explorer_white.png
  AssetGenImage get icExplorerWhite =>
      const AssetGenImage('assets/images/ic_explorer_white.png');

  /// File path: assets/images/img_girl_home.png
  AssetGenImage get imgGirlHome =>
      const AssetGenImage('assets/images/img_girl_home.png');

  /// File path: assets/images/img_login.png
  AssetGenImage get imgLogin =>
      const AssetGenImage('assets/images/img_login.png');

  /// File path: assets/images/img_password.png
  AssetGenImage get imgPassword =>
      const AssetGenImage('assets/images/img_password.png');

  /// File path: assets/images/img_sign.png
  AssetGenImage get imgSign =>
      const AssetGenImage('assets/images/img_sign.png');

  /// File path: assets/images/login_background.png
  AssetGenImage get loginBackground =>
      const AssetGenImage('assets/images/login_background.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        appBarBackground,
        icBack,
        icBrainWhite,
        icClock,
        icClockWhite,
        icExplorer,
        icExplorerWhite,
        imgGirlHome,
        imgLogin,
        imgPassword,
        imgSign,
        loginBackground
      ];
}

class Assets {
  const Assets._();

  static const $AssetsFilesGen files = $AssetsFilesGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
