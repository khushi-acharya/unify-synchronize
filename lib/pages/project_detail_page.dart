import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/mock_data.dart';
import '../widgets/common_widgets.dart';

class ProjectDetailPage extends StatefulWidget {
  final Project project;
  const ProjectDetailPage({super.key, required this.project});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  bool _applied = false;
  bool _isFavorited = false;
  int _selectedTab = 0;
  final _tabs = ['Overview', 'Team', 'Roles'];

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.project.isFavorited;
  }

  void _applyToProject(String role) {
    Navigator.pop(context);
    setState(() => _applied = true);
    showAppSnackbar(context, 'Application sent for $role!',
        icon: Icons.check_circle_outline);
  }

  void _showApplyDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Apply to Project',
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(widget.project.title,
                style: const TextStyle(
                    color: AppColors.teal,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            const Text('Select a Role',
                style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6)),
            const SizedBox(height: 10),
            ...widget.project.openRoles.map((role) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => _applyToProject(role),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.work_outline,
                              color: AppColors.teal, size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(role,
                                style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: AppColors.textMuted, size: 14),
                        ],
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                    _isFavorited
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: _isFavorited ? AppColors.teal : Colors.white),
                onPressed: () {
                  setState(() {
                    _isFavorited = !_isFavorited;
                    widget.project.isFavorited = _isFavorited;
                  });
                  showAppSnackbar(
                      context,
                      _isFavorited
                          ? 'Added to favorites'
                          : 'Removed from favorites',
                      icon: _isFavorited
                          ? Icons.bookmark
                          : Icons.bookmark_border);
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () => showAppSnackbar(
                    context, 'Share link copied!',
                    icon: Icons.link),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: p.cardColor,
                child: Center(
                  child: Icon(p.icon,
                      size: 80,
                      color: AppColors.teal.withOpacity(0.3)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.tealBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(p.category,
                            style: const TextStyle(
                                color: AppColors.teal,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1)),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(
                        label: p.status,
                        color: p.status == 'ACTIVE'
                            ? AppColors.activeGreen
                            : p.status == 'IDLE'
                                ? AppColors.idleOrange
                                : AppColors.pendingGray,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(p.title,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  Text(p.description,
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                          height: 1.6)),
                  const SizedBox(height: 20),

                  // Stats Row
                  Row(
                    children: [
                      _statItem(Icons.people_outline,
                          '${p.membersCount} members'),
                      const SizedBox(width: 20),
                      _statItem(Icons.calendar_today_outlined, p.dueDate),
                      const SizedBox(width: 20),
                      _statItem(Icons.work_outline,
                          '${p.openRoles.length} open roles'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Progress
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(p.progressLabel,
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            Text(
                                '${(p.progress * 100).toInt()}%',
                                style: const TextStyle(
                                    color: AppColors.teal,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        AppProgressBar(value: p.progress),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tabs
                  Row(
                    children: List.generate(_tabs.length, (i) {
                      final sel = i == _selectedTab;
                      return Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTab = i),
                          child: Column(
                            children: [
                              Text(_tabs[i],
                                  style: TextStyle(
                                      color: sel
                                          ? AppColors.textPrimary
                                          : AppColors.textMuted,
                                      fontSize: 14,
                                      fontWeight: sel
                                          ? FontWeight.w700
                                          : FontWeight.w400)),
                              const SizedBox(height: 4),
                              if (sel)
                                Container(
                                    height: 2,
                                    width: _tabs[i].length * 7.0,
                                    color: AppColors.teal),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  _buildTabContent(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _applied
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border:
                    Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.activeGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.activeGreen.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,
                        color: AppColors.activeGreen, size: 18),
                    SizedBox(width: 8),
                    Text('Application Submitted',
                        style: TextStyle(
                            color: AppColors.activeGreen,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                  ],
                ),
              ),
            )
          : p.openRoles.isEmpty
              ? null
              : Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border:
                        Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: PrimaryButton(
                    label: 'Apply to This Project →',
                    onPressed: _showApplyDialog,
                    height: 52,
                  ),
                ),
    );
  }

  Widget _statItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 14),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(
                color: AppColors.textMuted, fontSize: 12)),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildTeamTab();
      case 2:
        return _buildRolesTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildOverviewTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('About this Project',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Text(
                  '${widget.project.description}\n\nThis project is actively looking for talented collaborators to join the team. We work in agile sprints and communicate via Discord and Notion.',
                  style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      height: 1.6)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Stack & Tools',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Figma', 'Discord', 'Notion', 'GitHub', 'React']
                    .map((t) => SkillChip(label: t))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamTab() {
    final members = [
      {'name': 'Jordan Reed', 'role': 'Project Lead', 'color': AppColors.teal},
      {'name': 'Sarah Kim', 'role': 'Designer', 'color': AppColors.purple},
      {'name': 'Marcus Lin', 'role': 'Developer', 'color': AppColors.orange},
    ];
    return Column(
      children: members
          .map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: (m['color'] as Color).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (m['name'] as String).substring(0, 1),
                            style: TextStyle(
                                color: m['color'] as Color,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m['name'] as String,
                                style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                            Text(m['role'] as String,
                                style: const TextStyle(
                                    color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          color: AppColors.textMuted, size: 14),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildRolesTab() {
    if (widget.project.openRoles.isEmpty) {
      return const EmptyState(
        icon: Icons.work_off_outlined,
        title: 'No Open Roles',
        subtitle: 'This project has no open positions right now.',
      );
    }
    return Column(
      children: widget.project.openRoles
          .map((role) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                            color: AppColors.tealBg,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.work_outline,
                            color: AppColors.teal, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(role,
                                style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                            const Text('Open • Unpaid / Revenue Share',
                                style: TextStyle(
                                    color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.teal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Apply',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 12)),
                      ),
                    ],
                  ),
                  onTap: _showApplyDialog,
                ),
              ))
          .toList(),
    );
  }
}
