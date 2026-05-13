import 'package:flutter/material.dart';
import '../services/project_service.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../widgets/common_widgets.dart';
import 'notifications_page.dart';
import 'applications_page.dart';
import 'new_project_page.dart';
import 'firestore_project_detail_page.dart';
import 'profile_page.dart';

class DashboardPage extends StatefulWidget {
  final bool standalone;
  const DashboardPage({super.key, this.standalone = true});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void dispose() {
    super.dispose();
  }

  void _openProject(FirestoreProject project) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => FirestoreProjectDetailPage(project: project)),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: StreamBuilder<List<FirestoreProject>>(
                stream: ProjectService().streamProjects(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.teal),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading projects',
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                    );
                  }

                  final allProjects = snapshot.data ?? [];

                  if (allProjects.isEmpty) {
                    return EmptyState(
                      icon: Icons.inbox_outlined,
                      title: 'No projects available',
                      subtitle: 'Create one or check back later.',
                    );
                  }

                  final totalRoles = allProjects.fold<int>(
                      0, (sum, project) => sum + project.openRoles.length);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: _buildSummaryCards(
                            allProjects.length, totalRoles),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: RefreshIndicator(
                          color: AppColors.teal,
                          backgroundColor: AppColors.card,
                          onRefresh: () async =>
                              await Future.delayed(const Duration(seconds: 1)),
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: allProjects.length,
                            itemBuilder: (context, i) =>
                                _buildProjectCard(allProjects[i]),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push<bool>(
              context, MaterialPageRoute(builder: (_) => const NewProjectPage()));
          if (added == true && mounted) {
            setState(() {});
            showAppSnackbar(context, 'Project created successfully!',
                icon: Icons.check_circle_outline);
          }
        },
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    final unread = 0;
    final user = AuthService().getCurrentUser();
    final email = user?.email ?? '';
    final name = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : email.isNotEmpty
            ? email.split('@').first
            : 'Creator';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back,',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                      color: AppColors.teal,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your latest real-time projects are listed below.',
                  style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      height: 1.4),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textSecondary, size: 22),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsPage())),
              ),
              if (unread > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                        color: AppColors.orange, shape: BoxShape.circle),
                    child: Center(
                      child: Text('$unread',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(int totalProjects, int totalRoles) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
              'Live Projects', '$totalProjects', Icons.hub),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
              'Open Roles', '$totalRoles', Icons.group_work),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.tealBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.teal, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(FirestoreProject project) {
    final category = project.category.toLowerCase();
    final icon = {
      'art': Icons.palette_outlined,
      'games': Icons.sports_esports_outlined,
      'music': Icons.music_note_outlined,
      'apps': Icons.phone_android_outlined,
    }[category] ?? Icons.folder_outlined;
    final backgroundColor = {
      'art': const Color(0xFF0D3D30),
      'games': const Color(0xFF1A2035),
      'music': const Color(0xFF1A1535),
      'apps': const Color(0xFF1A2520),
    }[category] ?? const Color(0xFF2A1535);

    return GestureDetector(
      onTap: () => _openProject(project),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      icon,
                      size: 56,
                      color: AppColors.teal.withOpacity(0.25),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.tealBg,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.teal.withOpacity(0.4)),
                      ),
                      child: Text(project.category.toUpperCase(),
                          style: const TextStyle(
                              color: AppColors.teal,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.title,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(project.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          height: 1.5)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${project.openRoles.length} open roles',
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 11)),
                      Row(
                        children: const [
                          Icon(Icons.arrow_forward,
                              color: AppColors.teal, size: 16),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
