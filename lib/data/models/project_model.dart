import '../../domain/entities/apk_data.dart';
import '../../domain/entities/project_entity.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.description,
    required super.challenge,
    required super.solution,
    required super.impact,
    required super.techStack,
    required super.videoUrl,
    required super.imageUrls,
    required super.githubUrl,
    required super.demoUrl,
    super.apkData,
  });

  factory ProjectModel.fromMap(String id, Map<String, dynamic> map) {
    final apkMap = map['apkData'];
    final apkData = apkMap is Map<String, dynamic>
        ? ApkData(
            url: (apkMap['url'] ?? '') as String,
            version: (apkMap['version'] ?? '') as String,
            size: (apkMap['size'] ?? '') as String,
            date: (apkMap['date'] ?? '') as String,
          )
        : null;

    return ProjectModel(
      id: id,
      title: (map['title'] ?? '') as String,
      subtitle: (map['subtitle'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      challenge: (map['challenge'] ?? '') as String,
      solution: (map['solution'] ?? '') as String,
      impact: (map['impact'] ?? '') as String,
      techStack: (map['techStack'] as List<dynamic>? ?? [])
          .map((value) => value.toString())
          .toList(),
      videoUrl: (map['videoUrl'] ?? '') as String,
      imageUrls: (map['imageUrls'] as List<dynamic>? ?? [])
          .map((value) => value.toString())
          .toList(),
      githubUrl: (map['githubUrl'] ?? '') as String,
      demoUrl: (map['demoUrl'] ?? '') as String,
      apkData: apkData,
    );
  }
}
