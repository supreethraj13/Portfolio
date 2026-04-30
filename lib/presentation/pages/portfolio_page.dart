import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/di/service_locator.dart';
import '../../domain/entities/apk_data.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/submit_lead_use_case.dart';
import '../bloc/project_bloc.dart';
import '../bloc/project_state.dart';
import '../widgets/contact_form.dart';
import '../widgets/project_card.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _homeKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _contactKey = GlobalKey();

  final _resumeUrl = 'https://drive.google.com/file/d/1eq772Rl_wuySqZ8ebj3BWSb_DAQO2ZHt/view?usp=drive_link';
  final _githubUrl = 'https://github.com/supreethraj13';
  final _linkedInUrl = 'https://www.linkedin.com/in/supreeth-raj-42157929a';
  final _email = 'supreethrajs@gmail.com';
  final _phone = '+91 7892496621';
  final _location = 'Bengaluru';

  late final SubmitLeadUseCase _submitLeadUseCase;
  late final FirebaseAnalytics _analytics;

  @override
  void initState() {
    super.initState();
    _submitLeadUseCase = getIt<SubmitLeadUseCase>();
    _analytics = getIt<FirebaseAnalytics>();
  }

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
    required Key key,
    required String title,
    required Widget child,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 30),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0x66161B26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF242B3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            label: title,
            child: Text(
              title,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _heroSection(bool mobile) {
    final avatarSize = mobile ? 116.0 : 168.0;
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
        const Text(
          'L D Supreeth Raj',
          style: TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Flutter App Developer',
          style: TextStyle(fontSize: 22, color: Colors.white70),
        ),
        const SizedBox(height: 12),
        const Text(
          'I build scalable Flutter applications with BLoC and Firebase, focused on performance, reliability, and impactful user experiences.',
          style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(label: Text(_location)),
            Chip(label: Text(_email)),
            Chip(label: Text(_phone)),
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

    return Row(
      children: [
        Expanded(child: text),
        const SizedBox(width: 24),
        avatar,
      ],
    );
  }

  Widget _aboutStory() {
    final items = <Map<String, String>>[
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

    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: 450 + (index * 120)),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, (1 - value) * 12),
              child: child,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2A3142)),
              color: const Color(0x4419212E),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CC9F0),
                    shape: BoxShape.circle,
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
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['body']!,
                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _skillsGrid() {
    final skills = <String>[
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 600
            ? 3
            : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: skills.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 3.6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final name = skills[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _projectSection(ProjectState state) {
    Widget buildProjectCards(List<ProjectEntity> projects) {
      return Column(
        children: projects
            .map(
              (project) => Padding(
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
              ),
            )
            .toList(),
      );
    }

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

  PreferredSizeWidget _buildAppBar(bool mobile) {
    final items = _navItems();
    if (mobile) {
      return AppBar(title: const Text('Supreeth Raj'));
    }
    return AppBar(
      title: const Text('Supreeth Raj'),
      actions: items
          .map(
            (item) =>
                TextButton(onPressed: item.onTap, child: Text(item.label)),
          )
          .toList(),
    );
  }

  List<_NavItem> _navItems() {
    return [
      _NavItem('Home', () => _scrollTo(_homeKey)),
      _NavItem('Projects', () => _scrollTo(_projectsKey)),
      _NavItem('About', () => _scrollTo(_aboutKey)),
      _NavItem('Skills', () => _scrollTo(_skillsKey)),
      _NavItem('Contact', () => _scrollTo(_contactKey)),
      _NavItem('Resume', () => _openExternalUrl(_resumeUrl)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 900;
    final items = _navItems();

    return Scaffold(
      appBar: _buildAppBar(mobile),
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
                ],
              ),
            )
          : null,
      body: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionContainer(
                      key: _homeKey,
                      title: 'Home',
                      child: _heroSection(mobile),
                    ),
                    _sectionContainer(
                      key: _projectsKey,
                      title: 'Projects',
                      child: _projectSection(state),
                    ),
                    _sectionContainer(
                      key: _aboutKey,
                      title: 'About',
                      child: _aboutStory(),
                    ),
                    _sectionContainer(
                      key: _skillsKey,
                      title: 'Skills',
                      child: _skillsGrid(),
                    ),
                    _sectionContainer(
                      key: _contactKey,
                      title: 'Contact',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reach me at $_email or $_phone. Open to internship and collaboration opportunities.',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              OutlinedButton.icon(
                                onPressed: _linkedInUrl.isEmpty
                                    ? null
                                    : () => _openExternalUrl(_linkedInUrl),
                                icon: const Icon(Icons.person),
                                label: const Text('LinkedIn'),
                              ),
                              OutlinedButton.icon(
                                onPressed: _githubUrl.isEmpty
                                    ? null
                                    : () => _openExternalUrl(_githubUrl),
                                icon: const Icon(Icons.code),
                                label: const Text('GitHub'),
                              ),
                            ],
                          ),
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
          );
        },
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.onTap);

  final String label;
  final Future<void> Function() onTap;
}
