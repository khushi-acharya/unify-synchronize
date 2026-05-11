import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/mock_data.dart';
import '../widgets/common_widgets.dart';
import 'notifications_page.dart';
import 'applications_page.dart';
import 'new_project_page.dart';
import 'project_detail_page.dart';
import 'profile_page.dart';

class DashboardPage extends StatefulWidget {
  final bool standalone;
  const DashboardPage({super.key, this.standalone = true});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _data = MockDataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // FIXED: FAB to add a new project from anywhere on the dashboard
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
        elevation: 4,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.teal,
          backgroundColor: AppColors.card,
          onRefresh: () async =>
              await Future.delayed(const Duration(seconds: 1)),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                const SizedBox(height: 24),
                _buildHeading(),
                const SizedBox(height: 20),
                _buildStatsRow(),
                const SizedBox(height: 20),
                _buildProjectsSection(),
                const SizedBox(height: 20),
                _buildProjectProgress(),
                const SizedBox(height: 20),
                _buildApplications(),
                const SizedBox(height: 20),
                _buildRecentActivity(),
                const SizedBox(height: 20),
                _buildUpgradeBanner(),
                const SizedBox(height: 80), // space for FAB
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final unread = _data.unreadNotificationCount;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppLogoBar(),
        Row(
          children: [
            // FIXED: Notifications bell navigates to NotificationsPage
            Stack(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationsPage())),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border, width: 1.5),
                      color: AppColors.card,
                    ),
                    child: const Icon(Icons.notifications_outlined,
                        color: AppColors.textMuted, size: 18),
                  ),
                ),
                if (unread > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                          color: AppColors.orange, shape: BoxShape.circle),
                      child: Center(
                        child: Text('$unread',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            // Profile avatar — navigates to ProfilePage
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProfilePage())),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.teal, width: 2),
                  color: AppColors.tealBg,
                ),
                child: const Icon(Icons.person,
                    color: AppColors.teal, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
            children: [
              const TextSpan(
                  text: 'Hey, ',
                  style: TextStyle(color: AppColors.textPrimary)),
              TextSpan(
                  text: _data.currentUser.name.split(' ').first,
                  style: const TextStyle(color: AppColors.teal)),
              const TextSpan(
                  text: ' 👋',
                  style: TextStyle(color: AppColors.textPrimary)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
            'Manage your creative trajectory and active collaborations.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
            child: _statCard('Active Projects', '${_data.myProjects.length}',
                Icons.rocket_launch_outlined, AppColors.teal)),
        const SizedBox(width: 10),
        Expanded(
            child: _statCard('Applications', '${_data.applications.length}',
                Icons.send_outlined, AppColors.purple)),
        const SizedBox(width: 10),
        Expanded(
            child: _statCard('Followers', '${_data.currentUser.followersCount}',
                Icons.people_outline, AppColors.orange)),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              style:
                  const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Your Projects",
          badge: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border)),
            child: Row(
              children: const [
                Icon(Icons.rocket_launch_outlined,
                    color: AppColors.teal, size: 13),
                SizedBox(width: 4),
                Text('3 Active',
                    style: TextStyle(
                        color: AppColors.teal,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          // FIXED: "See all" snackbar replaced with navigation feedback
          actionLabel: 'New Project',
          onAction: () async {
            final added = await Navigator.push<bool>(
                context, MaterialPageRoute(builder: (_) => const NewProjectPage()));
            if (added == true && mounted) {
              setState(() {});
              showAppSnackbar(context, 'Project created successfully!',
                  icon: Icons.check_circle_outline);
            }
          },
        ),
        const SizedBox(height: 12),
        ..._data.myProjects
            .map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  // FIXED: project rows now navigate to ProjectDetailPage
                  child: _buildProjectRow(p),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildProjectRow(Map<String, dynamic> project) {
    // Build a stub Project to pass to detail page
    final stubProject = Project(
      id: project['title'].toString().toLowerCase().replaceAll(' ', '-'),
      category: 'Design',
      title: project['title'] as String,
      description: 'View full details for ${project['title']}.',
      progress: project['progress'] as double,
      progressLabel: '${((project['progress'] as double) * 100).toInt()}% Complete',
      membersCount: 3,
      cardColor: AppColors.tealBg,
      icon: project['icon'] as IconData,
      status: project['status'] as String,
      dueDate: 'Dec 31, 2024',
      openRoles: ['Designer', 'Developer'],
    );

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProjectDetailPage(project: stubProject))),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      color: AppColors.tealBg,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(project['icon'] as IconData,
                      color: AppColors.teal, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project['title'] as String,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      Text(project['role'] as String,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                StatusBadge(
                  label: project['status'] as String,
                  color: project['statusColor'] as Color,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right,
                    color: AppColors.textMuted, size: 16),
              ],
            ),
            const SizedBox(height: 10),
            AppProgressBar(value: project['progress'] as double),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectProgress() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Sprint Progress',
            actionLabel: 'Full Report',
            onAction: () =>
                showAppSnackbar(context, 'Timeline coming soon!'),
          ),
          const SizedBox(height: 16),
          _buildProgressItem(
              'Neo-Brutalism Kit', 0.85, 'Sprint 3 of 4', 'Due Friday'),
          const SizedBox(height: 14),
          _buildProgressItem('Brand Motion Reel', 0.42, 'Scene 12', null),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.tealBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('SCENE 12 COMPLETED',
                style: TextStyle(
                    color: AppColors.teal,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(
      String title, double value, String sub1, String? sub2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            Text('${(value * 100).toInt()}%',
                style: const TextStyle(
                    color: AppColors.teal,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        AppProgressBar(value: value),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(sub1,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 11)),
            if (sub2 != null)
              Text(sub2,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
      ],
    );
  }

  Widget _buildApplications() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'My Applications',
            actionLabel: 'View All',
            // FIXED: "View All" navigates to ApplicationsPage
            onAction: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ApplicationsPage())),
          ),
          const SizedBox(height: 12),
          ..._data.applications
              .take(2)
              .map((app) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildAppRow(app),
                  ))
              .toList(),
          // FIXED: "See all" link at bottom
          if (_data.applications.length > 2)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ApplicationsPage())),
                child: Text(
                  '+ ${_data.applications.length - 2} more',
                  style: const TextStyle(
                      color: AppColors.teal, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppRow(Application app) {
    return GestureDetector(
      onTap: () => showAppSnackbar(context, 'Viewing application for ${app.role}',
          icon: Icons.open_in_new),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app.role,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  Text(app.projectName,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ),
            StatusBadge(label: app.status, color: app.statusColor),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Recent Activity',
            actionLabel: 'View All',
            onAction: () =>
                showAppSnackbar(context, 'Full activity log coming soon!'),
          ),
          const SizedBox(height: 14),
          ...List.generate(
            _data.recentActivities.take(3).length,
            (i) {
              final act = _data.recentActivities[i];
              return Column(
                children: [
                  if (i > 0)
                    const Divider(color: AppColors.border, height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 4, right: 12),
                        decoration: BoxDecoration(
                            color: act.dotColor, shape: BoxShape.circle),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(act.title,
                                style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            Text(act.subtitle,
                                style: const TextStyle(
                                    color: AppColors.textMuted, fontSize: 12)),
                            const SizedBox(height: 2),
                            Text(act.time,
                                style: const TextStyle(
                                    color: AppColors.textMuted, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D5C52), Color(0xFF1ECFB3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Scale Your Reach',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text(
              'Upgrade to Pro and collaborate with top-tier agencies.',
              style: TextStyle(
                  color: Colors.white70, fontSize: 13, height: 1.4)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => showAppSnackbar(
                context, 'Pro plan coming soon!',
                icon: Icons.star_outline),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.tealDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              elevation: 0,
            ),
            child: const Text('Get Pro Now',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
