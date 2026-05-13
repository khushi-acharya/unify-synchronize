import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/mock_data.dart';
import '../widgets/common_widgets.dart';
import '../services/application_service.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appService = ApplicationService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Applications',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
      ),
      body: StreamBuilder<List<Application>>(
        stream: appService.streamUserApplications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.teal),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading applications',
                style: const TextStyle(color: AppColors.textMuted),
              ),
            );
          }

          final apps = snapshot.data ?? [];

          if (apps.isEmpty) {
            return const EmptyState(
              icon: Icons.send_outlined,
              title: 'No Applications Yet',
              subtitle:
                  'Apply to projects from the Explore page to see them here.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: apps.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) {
              final app = apps[i];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: app.statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.work_outline,
                          color: app.statusColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(app.role,
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(app.projectName,
                              style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('Applied ${app.appliedDate}',
                              style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 11)),
                        ],
                      ),
                    ),
                    StatusBadge(
                        label: app.status, color: app.statusColor),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
