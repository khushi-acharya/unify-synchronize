import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../services/application_service.dart';
import '../services/auth_service.dart';
import '../services/project_service.dart';
import '../utils/app_colors.dart';
import '../widgets/common_widgets.dart';

class FirestoreProjectDetailPage extends StatefulWidget {
  final FirestoreProject project;
  const FirestoreProjectDetailPage({super.key, required this.project});

  @override
  State<FirestoreProjectDetailPage> createState() =>
      _FirestoreProjectDetailPageState();
}

class _FirestoreProjectDetailPageState
    extends State<FirestoreProjectDetailPage> {
  final _appService = ApplicationService();
  late final String? _currentUserId;
  late final bool _isOwner;
  int _tabIndex = 0;
  bool _isProcessing = false;

  List<String> get _tabs =>
      _isOwner ? ['Overview', 'Applications', 'Team'] : ['Overview', 'Team'];

  @override
  void initState() {
    super.initState();
    _currentUserId = AuthService().getCurrentUser()?.uid;
    _isOwner = _currentUserId == widget.project.ownerId;
  }

  Future<void> _updateApplicationStatus(
      String applicationId, String newStatus) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      await _appService.updateApplicationStatus(applicationId, newStatus);
      if (mounted) {
        showAppSnackbar(context,
            'Application ${newStatus.toLowerCase()} successfully.',
            icon: newStatus == 'ACCEPTED'
                ? Icons.check_circle_outline
                : Icons.close);
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(context, 'Failed to update application.',
            color: AppColors.orange, icon: Icons.error_outline);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<String?> _getApplicationStatus(String role) async {
    if (_currentUserId == null) return null;
    try {
      final apps = await _appService.streamProjectApplications(widget.project.id).first;
      for (final app in apps) {
        if (app.role == role) {
          return app.status;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void _applyToProject(String role) async {
    setState(() => _isProcessing = true);
    try {
      await _appService.submitApplication(
        projectId: widget.project.id,
        projectName: widget.project.title,
        role: role,
      );
      if (mounted) {
        setState(() {});
        showAppSnackbar(context, 'Application sent for $role!',
            icon: Icons.check_circle_outline);
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(context, e.toString().replaceAll('Exception: ', ''),
            color: AppColors.orange, icon: Icons.error_outline);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
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
                  onPressed: _isProcessing ? null : () => Navigator.pop(ctx),
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
                  child: FutureBuilder<String?>(
                    future: _getApplicationStatus(role),
                    builder: (context, snapshot) {
                      final status = snapshot.data;
                      final isApplied = status != null;
                      final isAccepted = status == 'ACCEPTED';
                      
                      return GestureDetector(
                        onTap: (isApplied || _isProcessing) ? null : () => _applyToProject(role),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isAccepted ? AppColors.tealBg : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isAccepted ? AppColors.activeGreen : AppColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isAccepted ? Icons.check_circle : Icons.work_outline,
                                color: isAccepted ? AppColors.activeGreen : AppColors.teal,
                                size: 18,
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
                                    if (isApplied)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          isAccepted ? 'Accepted' : 'Applied',
                                          style: TextStyle(
                                            color: isAccepted
                                                ? AppColors.activeGreen
                                                : AppColors.textMuted,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                isAccepted ? Icons.check : Icons.arrow_forward_ios,
                                color: isAccepted ? AppColors.activeGreen : AppColors.textMuted,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Row(
      children: List.generate(_tabs.length, (index) {
        final selected = _tabIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _tabIndex = index),
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.teal : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              _tabs[index],
              style: TextStyle(
                color: selected ? Colors.black : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOverviewTab(FirestoreProject project) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Project Overview',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Text(project.description,
              style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  height: 1.6)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _detailChip('${project.openRoles.length} roles open'),
              _detailChip('Status: ${project.status}'),
              _detailChip('Created ${_displayDate(project.createdAt)}'),
            ],
          ),
          const SizedBox(height: 16),
          if (! _isOwner) ...[
            const Text('Apply for a role',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...project.openRoles.map((role) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FutureBuilder<String?>(
                    future: _getApplicationStatus(role),
                    builder: (context, snapshot) {
                      final status = snapshot.data;
                      final isApplied = status != null;
                      final isAccepted = status == 'ACCEPTED';
                      
                      String buttonLabel = 'Apply as $role';
                      Color buttonColor = AppColors.teal;
                      Color borderColor = AppColors.teal;
                      bool isDisabled = false;
                      
                      if (isAccepted) {
                        buttonLabel = 'Accepted for $role';
                        buttonColor = AppColors.activeGreen;
                        borderColor = AppColors.activeGreen;
                        isDisabled = true;
                      } else if (isApplied) {
                        buttonLabel = 'Applied for $role';
                        buttonColor = AppColors.textMuted;
                        borderColor = AppColors.border;
                        isDisabled = true;
                      }
                      
                      return OutlinedButton(
                        onPressed: (isDisabled || _isProcessing) ? null : () => _applyToProject(role),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(buttonLabel,
                            style: TextStyle(
                                color: buttonColor,
                                fontWeight: FontWeight.w700)),
                      );
                    },
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildApplicationsTab(FirestoreProject project) {
    return StreamBuilder<List<Application>>(
      stream: _appService.streamProjectApplications(project.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.teal));
        }
        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Text('Unable to load applications.',
                style: TextStyle(color: AppColors.textMuted)),
          );
        }

        final apps = snapshot.data ?? [];
        if (apps.isEmpty) {
          return const EmptyState(
            icon: Icons.group_add_outlined,
            title: 'No applications yet',
            subtitle: 'Applicants will appear here once they apply.',
          );
        }

        return Column(
          children: apps.map((app) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(app.applicantName.isNotEmpty
                                ? app.applicantName
                                : app.applicantEmail.isNotEmpty
                                    ? app.applicantEmail
                                    : 'Applicant'),
                            const SizedBox(height: 4),
                            Text(app.role,
                                style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                      StatusBadge(
                          label: app.status,
                          color: app.status == 'ACCEPTED'
                              ? AppColors.activeGreen
                              : app.status == 'REJECTED'
                                  ? AppColors.orange
                                  : AppColors.pendingGray),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Applied ${app.appliedDate}',
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 11)),
                  if (app.status == 'PENDING') ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isProcessing
                                ? null
                                : () => _updateApplicationStatus(
                                    app.id, 'ACCEPTED'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              side: const BorderSide(
                                  color: AppColors.activeGreen),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Approve',
                                style: TextStyle(
                                    color: AppColors.activeGreen,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isProcessing
                                ? null
                                : () => _updateApplicationStatus(
                                    app.id, 'REJECTED'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              side: const BorderSide(color: AppColors.orange),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Deny',
                                style: TextStyle(
                                    color: AppColors.orange,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTeamTab(FirestoreProject project) {
    return StreamBuilder<List<Application>>(
      stream: _appService.streamProjectApplications(project.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.teal));
        }
        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Text('Unable to load team members.',
                style: TextStyle(color: AppColors.textMuted)),
          );
        }

        final members = (snapshot.data ?? [])
            .where((app) => app.status == 'ACCEPTED')
            .toList();
        if (members.isEmpty) {
          return const EmptyState(
            icon: Icons.group_outlined,
            title: 'No team members yet',
            subtitle:
                'Approved applicants will appear here once they join the team.',
          );
        }

        return Column(
          children: members.map((member) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.tealBg,
                    child: Text(
                      member.applicantName.isNotEmpty
                          ? member.applicantName[0].toUpperCase()
                          : member.applicantEmail.isNotEmpty
                              ? member.applicantEmail[0].toUpperCase()
                              : '?',
                      style: const TextStyle(color: AppColors.teal),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.applicantName.isNotEmpty
                              ? member.applicantName
                              : member.applicantEmail,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(member.role,
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                  StatusBadge(
                    label: 'Team',
                    color: AppColors.activeGreen,
                  )
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTabContent(FirestoreProject project) {
    final tab = _tabs[_tabIndex];
    if (tab == 'Overview') {
      return _buildOverviewTab(project);
    }
    if (tab == 'Applications') {
      return _buildApplicationsTab(project);
    }
    return _buildTeamTab(project);
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final isOwner = _isOwner;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Project Details',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                    color: AppColors.tealBg.withOpacity(0.25),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18)),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.folder_open_outlined,
                      size: 72,
                      color: AppColors.teal.withOpacity(0.35),
                    ),
                  ),
                ),
                Padding(
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
                            child: Text(project.category.toUpperCase(),
                                style: const TextStyle(
                                    color: AppColors.teal,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1)),
                          ),
                          const SizedBox(width: 10),
                          StatusBadge(
                            label: project.status,
                            color: project.status == 'ACTIVE'
                                ? AppColors.activeGreen
                                : AppColors.pendingGray,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(project.title,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      Text(project.description,
                          style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14,
                              height: 1.6)),
                      const SizedBox(height: 20),
                      if (project.ownerName != null || project.ownerEmail != null)
                        Text(
                          'Owner: ${project.ownerName ?? project.ownerEmail ?? 'Unknown'}',
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _detailChip('${project.openRoles.length} roles'),
                          const SizedBox(width: 10),
                          _detailChip('Created ${_displayDate(project.createdAt)}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildTabSelector(),
          const SizedBox(height: 20),
          _buildTabContent(project),
        ],
      ),
    );
  }

  Widget _detailChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label,
          style: const TextStyle(
              color: AppColors.textMuted, fontSize: 12, letterSpacing: 0.2)),
    );
  }

  String _displayDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
