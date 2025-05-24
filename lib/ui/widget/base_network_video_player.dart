import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'base_progress_indicator.dart';

/// Một video player đơn giản sử dụng package chewie
/// để phát video từ mạng với giao diện điều khiển đầy đủ
class BaseNetworkVideoPlayer extends StatefulWidget {
  /// URL của video cần phát
  final String? videoUrl;

  /// Tỉ lệ khung hình (mặc định là 16:9)
  final double aspectRatio;

  /// Có tự động phát video không
  final bool autoPlay;

  /// Có lặp lại video không
  final bool looping;

  /// Có hiển thị các nút điều khiển không
  final bool showControls;

  /// Tiêu đề của video (hiển thị trên thanh điều khiển)
  final String? title;

  /// Callback khi video kết thúc
  final VoidCallback? onVideoEnded;

  /// URL có phải từ database không (cần thêm API_URL prefix)
  final bool? isFromDatabase;

  const BaseNetworkVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.aspectRatio = 16 / 9,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
    this.title,
    this.onVideoEnded,
    this.isFromDatabase = false,
  }) : super(key: key);

  @override
  State<BaseNetworkVideoPlayer> createState() => _BaseNetworkVideoPlayerState();
}

class _BaseNetworkVideoPlayerState extends State<BaseNetworkVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(BaseNetworkVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl ||
        oldWidget.isFromDatabase != widget.isFromDatabase) {
      _disposeControllers();
      _initializePlayer();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
  }

  String trimTrailingSlash(String input) {
    return input.endsWith('/') ? input.substring(0, input.length - 1) : input;
  }

  String _buildVideoUrl() {
    if (widget.isFromDatabase == true) {
      return '${trimTrailingSlash(dotenv.env['API_URL'] ?? '')}${widget.videoUrl}';
    }
    return widget.videoUrl ?? '';
  }

  Future<void> _initializePlayer() async {
    final String finalVideoUrl = _buildVideoUrl();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(finalVideoUrl));

    try {
      await _videoPlayerController.initialize();

      // Thêm listener để theo dõi khi video kết thúc
      if (widget.onVideoEnded != null) {
        _videoPlayerController.addListener(_onVideoPositionChanged);
      }

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: widget.aspectRatio,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        showControls: widget.showControls,
        allowFullScreen: true,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.white70,
          handleColor: Colors.white,
          backgroundColor: Colors.black54,
          bufferedColor: Colors.white24,
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        // Bổ sung tiêu đề nếu được cung cấp
        overlay: widget.title != null
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.title!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
            : null,
      );
    } catch (error) {
      setState(() {
        _errorMessage = "Không thể tải video: ${error.toString()}";
      });
    }

    setState(() {
      _isInitialized = true;
    });
  }

  void _onVideoPositionChanged() {
    final duration = _videoPlayerController.value.duration;
    final position = _videoPlayerController.value.position;

    // Kiểm tra xem video đã phát hết chưa
    if (duration.inMilliseconds > 0 &&
        position.inMilliseconds >= duration.inMilliseconds - 300 &&
        !widget.looping) {
      widget.onVideoEnded?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (!_isInitialized || _chewieController == null) {
      return const SizedBox(
        height: 50,
        child: Center(child: BaseProgressIndicator(color: Colors.black,)),
      );
    }

    // Wrap the Chewie widget with a SizedBox or AspectRatio to constrain its size
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }
}