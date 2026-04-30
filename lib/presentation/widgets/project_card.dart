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
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: Text(
              project.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(project.subtitle),
            onExpansionChanged: onExpanded,
            children: [
              const SizedBox(height: 8),
              if (videoUrl.isNotEmpty)
                LazyVideoPlayer(
                  videoUrl: videoUrl,
                  thumbnailUrl: thumbnail,
                ),
              if (imageUrls.isNotEmpty) ...[
                const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              Text(project.description),
              const SizedBox(height: 8),
              Text('Challenge: ${project.challenge}'),
              const SizedBox(height: 4),
              Text('Solution: ${project.solution}'),
              const SizedBox(height: 4),
              Text('Impact & Learning: ${project.impact}'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: project.techStack
                    .map((item) => Chip(label: Text(item)))
                    .toList(),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _openLink(project.githubUrl),
                    icon: const Icon(Icons.code),
                    label: const Text('GitHub'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _openLink(project.demoUrl),
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
