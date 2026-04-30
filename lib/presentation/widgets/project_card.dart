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

  Future<void> _openLink(String value) async {
    if (value.isEmpty) {
      return;
    }
    final uri = Uri.tryParse(value);
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          side: const BorderSide(color: Color(0xFF30405E)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            shape: Border.all(color: Colors.transparent),
            collapsedShape: Border.all(color: Colors.transparent),
            iconColor: const Color(0xFFAAC0FF),
            collapsedIconColor: const Color(0xFFAAC0FF),
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
                style: const TextStyle(color: Color(0xFFB8C8E8)),
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
                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length,
                    separatorBuilder: (_, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: imageUrls[index],
                          width: 180,
                          fit: BoxFit.cover,
                          placeholder: (_, placeholderUrl) =>
                              const ColoredBox(color: Color(0xFF11131A)),
                          errorWidget: (_, failedUrl, error) =>
                              const ColoredBox(color: Color(0xFF11131A)),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Text(
                project.description,
                style: const TextStyle(color: Color(0xFFD0DCFA), height: 1.5),
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
                        : () => _openLink(project.githubUrl),
                    icon: const Icon(Icons.code),
                    label: const Text('GitHub'),
                  ),
                  OutlinedButton.icon(
                    onPressed: project.demoUrl.trim().isEmpty
                        ? null
                        : () => _openLink(project.demoUrl),
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
                          await _openLink(apk.url);
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

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0x661A2740),
        border: Border.all(color: const Color(0xFF30405E)),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Color(0xFFD4E0FA),
            fontSize: 14,
            height: 1.45,
          ),
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(
                color: Colors.white,
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
