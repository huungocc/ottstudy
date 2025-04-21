import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'base_progress_indicator.dart';

/// Một video player đơn giản sử dụng package chewie
/// để phát video từ mạng với giao diện điều khiển đầy đủ
class BaseNetworkVideoPlayer extends StatefulWidget {
  /// URL của video cần phát
  final String videoUrl;

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

  const BaseNetworkVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.aspectRatio = 16 / 9,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
    this.title,
    this.onVideoEnded,
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
    if (oldWidget.videoUrl != widget.videoUrl) {
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

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

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

/// Một video player hỗ trợ lựa chọn chất lượng video
class AdaptiveQualityVideoPlayer extends StatefulWidget {
  /// Map của các chất lượng video và URL tương ứng
  final Map<String, String> videoQualities;

  /// Chất lượng mặc định được chọn
  final String defaultQuality;

  /// Các thuộc tính tùy chọn khác
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;
  final String? title;

  const AdaptiveQualityVideoPlayer({
    Key? key,
    required this.videoQualities,
    required this.defaultQuality,
    this.autoPlay = false,
    this.looping = false,
    this.aspectRatio = 16 / 9,
    this.title,
  }) : super(key: key);

  @override
  _AdaptiveQualityVideoPlayerState createState() => _AdaptiveQualityVideoPlayerState();
}

class _AdaptiveQualityVideoPlayerState extends State<AdaptiveQualityVideoPlayer> {
  late String _currentQuality;
  Duration _savedPosition = Duration.zero;
  bool _wasPlaying = false;

  @override
  void initState() {
    super.initState();
    _currentQuality = widget.videoQualities.containsKey(widget.defaultQuality)
        ? widget.defaultQuality
        : widget.videoQualities.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with a Container or SizedBox with explicit height or use AspectRatio
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        children: [
          // Use Positioned.fill to ensure the video player takes the full Stack space
          Positioned.fill(
            child: BaseNetworkVideoPlayer(
              key: ValueKey(_currentQuality), // Quan trọng: tạo instance mới khi đổi chất lượng
              videoUrl: widget.videoQualities[_currentQuality]!,
              aspectRatio: widget.aspectRatio,
              autoPlay: widget.autoPlay,
              looping: widget.looping,
              title: widget.title,
            ),
          ),

          // Nút chọn chất lượng
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.transparent,
              child: PopupMenuButton<String>(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 28,
                ),
                tooltip: "Chọn chất lượng",
                onSelected: (quality) {
                  setState(() {
                    _currentQuality = quality;
                  });
                },
                itemBuilder: (context) => widget.videoQualities.keys.map((quality) {
                  return PopupMenuItem<String>(
                    value: quality,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(quality),
                        if (_currentQuality == quality)
                          const Icon(Icons.check, size: 18)
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}