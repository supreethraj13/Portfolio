import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/project_entity.dart';
import 'lazy_video_player.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    required this.project,
    required this.onExpanded,
    required this.onApkDownload,
    super.key,
  });

  final ProjectEntity project;
  final ValueChanged<bool> onExpanded;
  final VoidCallback onApkDownload;

  void _showLaunchError(BuildContext context, String message) {
    if (!context.mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openLink(BuildContext context, String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      _showLaunchError(context, 'Link is not available.');
      return;
    }
    final uri = Uri.tryParse(trimmed);
    if (uri == null) {
      _showLaunchError(context, 'Link format is invalid.');
      return;
    }
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!context.mounted) {
        return;
      }
      if (!launched) {
        _showLaunchError(context, 'Unable to open the link.');
      }
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      _showLaunchError(context, 'Failed to open link: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final apk = project.apkData;
    final imageUrls = project.imageUrls
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toList();
    final thumbnail = imageUrls.isNotEmpty ? imageUrls.first : '';
    final videoUrl = project.videoUrl.trim();

    return Semantics(
      label: 'Project ${project.title}',
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark ? const Color(0xFF30405E) : const Color(0xFFD3DCF3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            shape: Border.all(color: Colors.transparent),
            collapsedShape: Border.all(color: Colors.transparent),
            iconColor: isDark
                ? const Color(0xFFAAC0FF)
                : const Color(0xFF4E6494),
            collapsedIconColor: isDark
                ? const Color(0xFFAAC0FF)
                : const Color(0xFF4E6494),
            title: Text(
              project.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                project.subtitle,
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFFB8C8E8)
                      : const Color(0xFF465A83),
                ),
              ),
            ),
            onExpansionChanged: onExpanded,
            children: [
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: project.techStack
                    .take(4)
                    .map((item) => Chip(label: Text(item)))
                    .toList(),
              ),
              if (videoUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: LazyVideoPlayer(
                    videoUrl: videoUrl,
                    thumbnailUrl: thumbnail,
                  ),
                ),
              if (imageUrls.isNotEmpty) ...[
                const SizedBox(height: 14),
                _ProjectImageStrip(imageUrls: imageUrls),
              ],
              const SizedBox(height: 14),
              Text(
                project.description,
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFFD0DCFA)
                      : const Color(0xFF2F3F5E),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              _DetailBlock(title: 'Challenge', content: project.challenge),
              const SizedBox(height: 8),
              _DetailBlock(title: 'Solution', content: project.solution),
              const SizedBox(height: 8),
              _DetailBlock(title: 'Impact', content: project.impact),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  OutlinedButton.icon(
                    onPressed: project.githubUrl.trim().isEmpty
                        ? null
                        : () => _openLink(context, project.githubUrl),
                    icon: const Icon(Icons.code),
                    label: const Text('GitHub'),
                  ),
                  OutlinedButton.icon(
                    onPressed: project.demoUrl.trim().isEmpty
                        ? null
                        : () => _openLink(context, project.demoUrl),
                    icon: const Icon(Icons.public),
                    label: const Text('Live Demo'),
                  ),
                  if (apk != null)
                    Tooltip(
                      message:
                          'Version ${apk.version} | ${apk.size} | ${apk.date}',
                      child: FilledButton.icon(
                        onPressed: () async {
                          onApkDownload();
                          await _openLink(context, apk.url);
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download APK'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectImageStrip extends StatelessWidget {
  const _ProjectImageStrip({required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final double tileHeight = compact ? 280.0 : 300.0;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final frameColor = isDark
            ? const Color(0xFF0D111A)
            : const Color(0xFFEAF0FF);

        return SizedBox(
          height: tileHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            separatorBuilder: (_, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _ProjectImageTile(
                imageUrl: imageUrls[index],
                height: tileHeight,
                minWidth: compact ? 150.0 : 170.0,
                maxWidth: compact
                    ? (constraints.maxWidth * 0.88)
                          .clamp(260.0, 380.0)
                          .toDouble()
                    : (constraints.maxWidth * 0.42)
                          .clamp(340.0, 500.0)
                          .toDouble(),
                frameColor: frameColor,
                borderColor: isDark
                    ? const Color(0xFF25334F)
                    : const Color(0xFFD3DCF3),
                errorColor: isDark ? Colors.white54 : Colors.black45,
              );
            },
          ),
        );
      },
    );
  }
}

class _ProjectImageTile extends StatefulWidget {
  const _ProjectImageTile({
    required this.imageUrl,
    required this.height,
    required this.minWidth,
    required this.maxWidth,
    required this.frameColor,
    required this.borderColor,
    required this.errorColor,
  });

  final String imageUrl;
  final double height;
  final double minWidth;
  final double maxWidth;
  final Color frameColor;
  final Color borderColor;
  final Color errorColor;

  @override
  State<_ProjectImageTile> createState() => _ProjectImageTileState();
}

class _ProjectImageTileState extends State<_ProjectImageTile> {
  double? _aspectRatio;
  ImageStream? _imageStream;
  ImageStreamListener? _imageListener;

  @override
  void initState() {
    super.initState();
    _loadAspectRatio();
  }

  @override
  void didUpdateWidget(covariant _ProjectImageTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _aspectRatio = null;
      _loadAspectRatio();
    }
  }

  void _loadAspectRatio() {
    final previousListener = _imageListener;
    if (previousListener != null) {
      _imageStream?.removeListener(previousListener);
    }
    final provider = CachedNetworkImageProvider(widget.imageUrl);
    final stream = provider.resolve(const ImageConfiguration());
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        final image = info.image;
        final ratio = image.width / image.height;
        if (mounted) {
          setState(() => _aspectRatio = ratio);
        }
        stream.removeListener(listener);
      },
      onError: (_, _) {
        stream.removeListener(listener);
      },
    );
    _imageStream = stream;
    _imageListener = listener;
    stream.addListener(listener);
  }

  @override
  void dispose() {
    final listener = _imageListener;
    if (listener != null) {
      _imageStream?.removeListener(listener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratio = _aspectRatio ?? 16 / 9;
    final width = (widget.height * ratio)
        .clamp(widget.minWidth, widget.maxWidth)
        .toDouble();

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.frameColor,
          border: Border.all(color: widget.borderColor),
        ),
        child: SizedBox(
          width: width,
          height: widget.height,
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.contain,
            placeholder: (_, placeholderUrl) =>
                ColoredBox(color: widget.frameColor),
            errorWidget: (_, failedUrl, error) => Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: widget.errorColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark ? const Color(0x661A2740) : const Color(0xFFF0F5FF),
        border: Border.all(
          color: isDark ? const Color(0xFF30405E) : const Color(0xFFD3DCF3),
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: isDark ? const Color(0xFFD4E0FA) : const Color(0xFF2F3F5E),
            fontSize: 14,
            height: 1.45,
          ),
          children: [
            TextSpan(
              text: '$title: ',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1C2D4E),
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(text: content),
          ],
        ),
      ),
    );
  }
}
