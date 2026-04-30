import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LazyVideoPlayer extends StatefulWidget {
  const LazyVideoPlayer({
    required this.videoUrl,
    required this.thumbnailUrl,
    super.key,
  });

  final String videoUrl;
  final String thumbnailUrl;

  @override
  State<LazyVideoPlayer> createState() => _LazyVideoPlayerState();
}

class _LazyVideoPlayerState extends State<LazyVideoPlayer> {
  VideoPlayerController? _controller;
  YoutubePlayerController? _youtubeController;
  String? _youtubeId;
  bool _initializing = false;
  bool _isVisible = false;
  bool _isHovering = false;
  bool _videoUnavailable = false;

  @override
  void initState() {
    super.initState();
    _setupYoutubeController();
  }

  @override
  void didUpdateWidget(covariant LazyVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _youtubeController?.close();
      _youtubeController = null;
      _youtubeId = null;
      _setupYoutubeController();
    }
  }

  void _setupYoutubeController() {
    _youtubeId = _extractYoutubeId(widget.videoUrl);
    if (_youtubeId == null) {
      return;
    }
    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: _youtubeId!,
      autoPlay: false,
      params: const YoutubePlayerParams(
        mute: true,
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
      ),
    );
  }

  String? _extractYoutubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }

    if (uri.host.contains('youtu.be')) {
      final segments = uri.pathSegments;
      return segments.isNotEmpty ? segments.first : null;
    }

    if (uri.host.contains('youtube.com')) {
      final v = uri.queryParameters['v'];
      if (v != null && v.isNotEmpty) {
        return v;
      }

      final segments = uri.pathSegments;
      final shortsIndex = segments.indexOf('shorts');
      if (shortsIndex >= 0 && shortsIndex + 1 < segments.length) {
        return segments[shortsIndex + 1];
      }

      final embedIndex = segments.indexOf('embed');
      if (embedIndex >= 0 && embedIndex + 1 < segments.length) {
        return segments[embedIndex + 1];
      }
    }

    return null;
  }

  Future<void> _initializeIfNeeded() async {
    if (_controller != null ||
        _youtubeController != null ||
        _initializing ||
        _videoUnavailable ||
        widget.videoUrl.isEmpty) {
      return;
    }
    _initializing = true;
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
      });
      if (_isVisible || _isHovering) {
        await controller.play();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _videoUnavailable = true;
        });
      } else {
        _videoUnavailable = true;
      }
    } finally {
      _initializing = false;
    }
  }

  Future<void> _onVisibilityChanged(VisibilityInfo info) async {
    final isVisible = info.visibleFraction > 0.35;
    _isVisible = isVisible;
    if (_youtubeController != null) {
      if (isVisible) {
        _youtubeController!.playVideo();
      } else {
        _youtubeController!.pauseVideo();
      }
      return;
    }
    if (isVisible) {
      await _initializeIfNeeded();
      await _controller?.play();
    } else {
      await _controller?.pause();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _youtubeController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) async {
        _isHovering = true;
        if (_youtubeController != null) {
          _youtubeController!.playVideo();
          return;
        }
        await _initializeIfNeeded();
        await _controller?.play();
      },
      onExit: (_) async {
        _isHovering = false;
        if (_youtubeController != null && !_isVisible) {
          _youtubeController!.pauseVideo();
          return;
        }
        if (!_isVisible) {
          await _controller?.pause();
        }
      },
      child: VisibilityDetector(
        key: ValueKey(widget.videoUrl),
        onVisibilityChanged: _onVisibilityChanged,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _youtubeController != null
                ? YoutubePlayer(controller: _youtubeController!)
                : _controller != null && _controller!.value.isInitialized
                ? GestureDetector(
                    onTap: () async {
                      final controller = _controller!;
                      if (controller.value.isPlaying) {
                        await controller.pause();
                      } else {
                        await controller.play();
                      }
                    },
                    child: VideoPlayer(_controller!),
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, placeholderUrl) =>
                            const ColoredBox(color: Color(0xFF11131A)),
                        errorWidget: (_, failedUrl, error) =>
                            const ColoredBox(color: Color(0xFF11131A)),
                      ),
                      const Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 64,
                          color: Colors.white70,
                        ),
                      ),
                      if (_videoUnavailable)
                        const Positioned(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          child: Text(
                            'Preview unavailable for this video source',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
