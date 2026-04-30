import 'package:equatable/equatable.dart';

import 'apk_data.dart';

class ProjectEntity extends Equatable {
  const ProjectEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.challenge,
    required this.solution,
    required this.impact,
    required this.techStack,
    required this.videoUrl,
    required this.imageUrls,
    required this.githubUrl,
    required this.demoUrl,
    this.apkData,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String challenge;
  final String solution;
  final String impact;
  final List<String> techStack;
  final String videoUrl;
  final List<String> imageUrls;
  final String githubUrl;
  final String demoUrl;
  final ApkData? apkData;

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    description,
    challenge,
    solution,
    impact,
    techStack,
    videoUrl,
    imageUrls,
    githubUrl,
    demoUrl,
    apkData,
  ];
}
