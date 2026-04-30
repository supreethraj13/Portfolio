import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/di/service_locator.dart';
import '../../domain/entities/apk_data.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/submit_lead_use_case.dart';
import '../bloc/project_bloc.dart';
import '../bloc/project_state.dart';
import '../widgets/contact_form.dart';
import '../widgets/project_card.dart';

class PortfolioPage extends StatelessWidget {
  PortfolioPage({super.key});
  static const List<Map<String, String>> _defaultAboutItems = [
    {
      'title': 'Education',
      'body':
          'Pursuing BE in Information Science at Sir M Visvesvaraya Institute of Technology (2023-2027) with 8.1 GPA, after scoring 86% at MES Kishore Kendra PU College.',
    },
    {
      'title': 'Experience',
      'body':
          'Mobile App Developer Intern at WhiterApps (Jan 2026 - Present), architecting cross-platform Flutter apps with BLoC and integrating Firebase for real-time sync, cloud storage, and secure auth.',
    },
    {
      'title': 'Leadership & Learning',
      'body':
          'Solved 190+ LeetCode problems, mentored 25+ students in Flutter during CSOC, and contributed to TechHub and GLUG workshops and ideathons.',
    },
  ];
  static const List<String> _defaultSkills = [
    'Flutter',
    'BLoC',
    'Firebase Firestore',
    'Provider',
    'Dart',
    'C/C++',
    'Python',
    'SQL',
    'Google Maps API',
    'SQLite',
    'MongoDB',
    'Git/GitHub',
  ];

  final _homeKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _contactKey = GlobalKey();

  final _defaultResumeUrl =
      'https://drive.google.com/file/d/1eq772Rl_wuySqZ8ebj3BWSb_DAQO2ZHt/view?usp=drive_link';
  final _defaultGithubUrl = 'https://github.com/supreethraj13';
  final _defaultLinkedInUrl =
      'https://www.linkedin.com/in/supreeth-raj-42157929a';
  final _defaultEmail = 'supreethrajs@gmail.com';
  final _defaultPhone = '+91 7892496621';
  final _defaultLocation = 'Bengaluru';

  final GetProfileUseCase _getProfileUseCase = getIt<GetProfileUseCase>();
  final SubmitLeadUseCase _submitLeadUseCase = getIt<SubmitLeadUseCase>();
  final FirebaseAnalytics _analytics = getIt<FirebaseAnalytics>();
  late final Future<Map<String, dynamic>?> _profileFuture = _getProfileUseCase
      .call();

  Future<void> _scrollTo(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) {
      return;
    }
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  Future<void> _openExternalUrl(String value) async {
    if (value.trim().isEmpty) {
      return;
    }
    final uri = Uri.tryParse(value);
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _sectionContainer({
    required BuildContext context,
    required Key key,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      key: key,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: const Color(0xCC141C2B),
          border: Border.all(color: const Color(0xFF2A3650)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              label: title,
              child: Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }

  Widget _heroSection(bool mobile, _ProfileContent profile) {
    final avatarSize = mobile ? 120.0 : 176.0;
    final titleSize = mobile ? 36.0 : 52.0;
    final avatar = ClipOval(
      child: Image.asset(
        'assets/images/supreeth_profile.jpg',
        width: avatarSize,
        height: avatarSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: avatarSize,
          height: avatarSize,
          color: const Color(0xFF1E2433),
          alignment: Alignment.center,
          child: const Icon(Icons.person, size: 48, color: Colors.white70),
        ),
      ),
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          profile.name,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
            height: 1.06,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          profile.role,
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFFB8C8E8),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          profile.summary,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFFD0DCFA),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            Chip(
              avatar: const Icon(Icons.location_on_outlined, size: 16),
              label: Text(profile.location),
            ),
            Chip(
              avatar: const Icon(Icons.email_outlined, size: 16),
              label: Text(profile.email),
            ),
            Chip(
              avatar: const Icon(Icons.call_outlined, size: 16),
              label: Text(profile.phone),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: profile.resumeUrl.isEmpty
                  ? null
                  : () => _openExternalUrl(profile.resumeUrl),
              icon: const Icon(Icons.description_outlined),
              label: const Text('View Resume'),
            ),
            OutlinedButton.icon(
              onPressed: () => _scrollTo(_contactKey),
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Let\'s Connect'),
            ),
          ],
        ),
      ],
    );

    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text,
          const SizedBox(height: 20),
          Align(alignment: Alignment.center, child: avatar),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x5598B4FF), Color(0x2222D3EE)],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xFF0E1523),
        ),
        child: Row(
          children: [
            Expanded(child: text),
            const SizedBox(width: 24),
            avatar,
          ],
        ),
      ),
    );
  }

  Widget _aboutStory(List<Map<String, String>> aboutItems) {
    return Column(
      children: aboutItems.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF30405E)),
            color: const Color(0x99202B40),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C9CFF).withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Color(0xFFAAC0FF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['body']!,
                      style: const TextStyle(
                        color: Color(0xFFD3DDF5),
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _skillsGrid(List<String> skills) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 600
            ? 3
            : 2;
        const spacing = 8.0;
        final tileWidth =
            (constraints.maxWidth - ((crossAxisCount - 1) * spacing)) /
            crossAxisCount;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: skills.map((name) {
            return SizedBox(
              width: tileWidth,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0x557C9CFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 16,
                          color: Color(0xFFD8E4FF),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _projectSection() {
    Widget buildProjectCards(List<ProjectEntity> projects) {
      return Column(
        children: projects.asMap().entries.map((entry) {
          final project = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: ProjectCard(
              project: project,
              onExpanded: (expanded) async {
                if (expanded) {
                  await _analytics.logEvent(
                    name: 'project_expanded',
                    parameters: {
                      'project_id': project.id,
                      'project_title': project.title,
                    },
                  );
                }
              },
              onApkDownload: () async {
                await _analytics.logEvent(
                  name: 'apk_download_clicked',
                  parameters: {
                    'project_id': project.id,
                    'project_title': project.title,
                  },
                );
              },
            ),
          );
        }).toList(),
      );
    }

    return BlocBuilder<ProjectBloc, ProjectState>(
      buildWhen: (previous, current) {
        if (previous.runtimeType != current.runtimeType) {
          return true;
        }
        if (previous is ProjectLoaded && current is ProjectLoaded) {
          return previous.projects != current.projects;
        }
        if (previous is ProjectError && current is ProjectError) {
          return previous.message != current.message;
        }
        return false;
      },
      builder: (context, state) {
        if (state is ProjectLoading || state is ProjectInitial) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ProjectLoaded && state.projects.isNotEmpty) {
          return buildProjectCards(state.projects);
        }

        if (state is ProjectError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0x66B00020),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0x99FF6B6B)),
                ),
                child: Text(
                  'Could not fetch projects from Firestore: ${state.message}',
                  style: const TextStyle(color: Color(0xFFFFD7D7)),
                ),
              ),
              buildProjectCards(_resumeProjects()),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'No Firestore projects found yet. Showing local template projects.',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            buildProjectCards(_resumeProjects()),
          ],
        );
      },
    );
  }

  List<ProjectEntity> _resumeProjects() {
    return const [
      ProjectEntity(
        id: 'favplaces',
        title: 'FavPlaces - Personal Location Journal',
        subtitle: 'Flutter, SQLite, Google Maps API',
        description:
            'Feature-rich journaling app to catalog places with high-resolution images, custom metadata, and precise GPS coordinates.',
        challenge:
            'Build a location journal that works smoothly with map selection and keeps data reliable offline.',
        solution:
            'Integrated Google Maps for location picking and previews, and used SQLite with Provider for robust local state and storage.',
        impact:
            'Created a dependable offline-first experience for personal place tracking with rich contextual details.',
        techStack: ['Flutter', 'SQLite', 'Google Maps API', 'Provider', 'Dart'],
        videoUrl: '',
        imageUrls: [
          'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=1200&q=80',
        ],
        githubUrl: 'https://github.com/search?q=FavPlaces',
        demoUrl: '',
        apkData: ApkData(
          url: '/downloads/favplaces_v1.0.0_2026-01-05.apk',
          version: '1.0.0',
          size: '24 MB',
          date: '2026-01-05',
        ),
      ),
      ProjectEntity(
        id: 'suraksha-setu',
        title: 'SURAKSHA-SETU - Tourist Safety Monitoring',
        subtitle: 'Flutter, Google Maps API, Blockchain',
        description:
            'Smart India Hackathon 2025 project focused on live tracking, geospatial visualization, and emergency safety workflows.',
        challenge:
            'Enable proactive tourist safety monitoring with real-time alerts while preserving identity trust and low-bandwidth performance.',
        solution:
            'Built geofencing-based safety scoring, multi-channel SOS alerts with live coordinates, and blockchain DID-based verification.',
        impact:
            'Improved incident response and situational awareness in high-risk zones through automated safety intelligence.',
        techStack: ['Flutter', 'Google Maps API', 'Blockchain DID', 'Provider'],
        videoUrl: '',
        imageUrls: [
          'https://images.unsplash.com/photo-1526498460520-4c246339dccb?w=1200&q=80',
        ],
        githubUrl: 'https://github.com/search?q=Tourist',
        demoUrl: '',
      ),
    ];
  }

  PreferredSizeWidget _buildAppBar(bool mobile, String resumeUrl) {
    final items = _navItems();
    if (mobile) {
      return AppBar(
        title: const Text('Supreeth Raj'),
        actions: [
          IconButton(
            onPressed: resumeUrl.isEmpty
                ? null
                : () => _openExternalUrl(resumeUrl),
            tooltip: 'Resume',
            icon: const Icon(Icons.description_outlined),
          ),
        ],
      );
    }
    return AppBar(
      title: const Text('Supreeth Raj'),
      actions: [
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(right: 6),
            child: TextButton(onPressed: item.onTap, child: Text(item.label)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: FilledButton.icon(
            onPressed: resumeUrl.isEmpty
                ? null
                : () => _openExternalUrl(resumeUrl),
            icon: const Icon(Icons.description_outlined),
            label: const Text('Resume'),
          ),
        ),
      ],
    );
  }

  List<_NavItem> _navItems() {
    return [
      _NavItem('Home', () => _scrollTo(_homeKey)),
      _NavItem('Projects', () => _scrollTo(_projectsKey)),
      _NavItem('About', () => _scrollTo(_aboutKey)),
      _NavItem('Skills', () => _scrollTo(_skillsKey)),
      _NavItem('Contact', () => _scrollTo(_contactKey)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 900;
    final items = _navItems();
    final fallbackProfile = _ProfileContent(
      name: 'L D Supreeth Raj',
      role: 'Flutter App Developer',
      summary:
          'I build scalable Flutter applications with BLoC and Firebase, focused on performance, reliability, and impactful user experiences.',
      location: _defaultLocation,
      email: _defaultEmail,
      phone: _defaultPhone,
      resumeUrl: _defaultResumeUrl,
      githubUrl: _defaultGithubUrl,
      linkedInUrl: _defaultLinkedInUrl,
      contactIntro:
          'Open to internships and collaboration opportunities. Reach out and I will get back quickly.',
      skills: _defaultSkills,
      aboutItems: _defaultAboutItems,
    );

    return FutureBuilder<Map<String, dynamic>?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        final profile = _ProfileContent.fromMap(snapshot.data, fallbackProfile);

        return Scaffold(
          appBar: _buildAppBar(mobile, profile.resumeUrl),
          drawer: mobile
              ? Drawer(
                  child: ListView(
                    children: [
                      const DrawerHeader(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Navigate',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      ...items.map(
                        (item) => ListTile(
                          title: Text(item.label),
                          onTap: () async {
                            Navigator.of(context).pop();
                            await item.onTap();
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Resume'),
                        leading: const Icon(Icons.description_outlined),
                        onTap: () async {
                          Navigator.of(context).pop();
                          await _openExternalUrl(profile.resumeUrl);
                        },
                      ),
                    ],
                  ),
                )
              : null,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A1020), Color(0xFF080A12)],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionContainer(
                        context: context,
                        key: _homeKey,
                        title: 'Home',
                        child: _heroSection(mobile, profile),
                      ),
                      _sectionContainer(
                        context: context,
                        key: _projectsKey,
                        title: 'Projects',
                        child: _projectSection(),
                      ),
                      _sectionContainer(
                        context: context,
                        key: _aboutKey,
                        title: 'About',
                        child: _aboutStory(profile.aboutItems),
                      ),
                      _sectionContainer(
                        context: context,
                        key: _skillsKey,
                        title: 'Skills',
                        child: _skillsGrid(profile.skills),
                      ),
                      _sectionContainer(
                        context: context,
                        key: _contactKey,
                        title: 'Contact',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.contactIntro,
                              style: const TextStyle(
                                color: Color(0xFFD0DCFA),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                Chip(
                                  avatar: const Icon(
                                    Icons.email_outlined,
                                    size: 16,
                                  ),
                                  label: Text(profile.email),
                                ),
                                Chip(
                                  avatar: const Icon(
                                    Icons.call_outlined,
                                    size: 16,
                                  ),
                                  label: Text(profile.phone),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: profile.linkedInUrl.isEmpty
                                      ? null
                                      : () => _openExternalUrl(
                                          profile.linkedInUrl,
                                        ),
                                  icon: const Icon(Icons.person),
                                  label: const Text('LinkedIn'),
                                ),
                                OutlinedButton.icon(
                                  onPressed: profile.githubUrl.isEmpty
                                      ? null
                                      : () =>
                                            _openExternalUrl(profile.githubUrl),
                                  icon: const Icon(Icons.code),
                                  label: const Text('GitHub'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Divider(height: 1),
                            const SizedBox(height: 16),
                            ContactForm(submitLeadUseCase: _submitLeadUseCase),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.onTap);

  final String label;
  final Future<void> Function() onTap;
}

class _ProfileContent {
  const _ProfileContent({
    required this.name,
    required this.role,
    required this.summary,
    required this.location,
    required this.email,
    required this.phone,
    required this.resumeUrl,
    required this.githubUrl,
    required this.linkedInUrl,
    required this.contactIntro,
    required this.skills,
    required this.aboutItems,
  });

  final String name;
  final String role;
  final String summary;
  final String location;
  final String email;
  final String phone;
  final String resumeUrl;
  final String githubUrl;
  final String linkedInUrl;
  final String contactIntro;
  final List<String> skills;
  final List<Map<String, String>> aboutItems;

  factory _ProfileContent.fromMap(
    Map<String, dynamic>? raw,
    _ProfileContent fallback,
  ) {
    final source = raw ?? const <String, dynamic>{};
    return _ProfileContent(
      name: _string(source['name'], fallback.name),
      role: _string(source['role'], fallback.role),
      summary: _string(source['summary'], fallback.summary),
      location: _string(source['location'], fallback.location),
      email: _string(source['email'], fallback.email),
      phone: _string(source['phone'], fallback.phone),
      resumeUrl: _string(source['resumeUrl'], fallback.resumeUrl),
      githubUrl: _string(source['githubUrl'], fallback.githubUrl),
      linkedInUrl: _string(source['linkedInUrl'], fallback.linkedInUrl),
      contactIntro: _string(source['contactIntro'], fallback.contactIntro),
      skills: _stringList(source['skills'], fallback.skills),
      aboutItems: _aboutList(source['aboutItems'], fallback.aboutItems),
    );
  }

  static String _string(Object? value, String fallback) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  static List<String> _stringList(Object? value, List<String> fallback) {
    if (value is! List) {
      return fallback;
    }
    final mapped = value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
    return mapped.isEmpty ? fallback : mapped;
  }

  static List<Map<String, String>> _aboutList(
    Object? value,
    List<Map<String, String>> fallback,
  ) {
    if (value is! List) {
      return fallback;
    }
    final mapped = <Map<String, String>>[];
    for (final item in value) {
      if (item is! Map) {
        continue;
      }
      final title = item['title']?.toString().trim() ?? '';
      final body = item['body']?.toString().trim() ?? '';
      if (title.isEmpty || body.isEmpty) {
        continue;
      }
      mapped.add({'title': title, 'body': body});
    }
    return mapped.isEmpty ? fallback : mapped;
  }
}
