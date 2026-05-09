import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/mock_data.dart';
import '../widgets/common_widgets.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _data = MockDataService();

  void _markAllRead() {
    setState(() {
      for (final n in _data.notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text('Mark all read',
                style: TextStyle(color: AppColors.teal, fontSize: 13)),
          ),
        ],
      ),
      body: _data.notifications.isEmpty
          ? const EmptyState(
              icon: Icons.notifications_off_outlined,
              title: 'No Notifications',
              subtitle: 'You\'re all caught up!',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _data.notifications.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: AppColors.border, height: 1),
              itemBuilder: (context, i) {
                final n = _data.notifications[i];
                return InkWell(
                  onTap: () => setState(() => n.isRead = true),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: n.isRead
                          ? Colors.transparent
                          : AppColors.tealBg.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: n.iconColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              Icon(n.icon, color: n.iconColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(n.title,
                                        style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 14,
                                            fontWeight: n.isRead
                                                ? FontWeight.w500
                                                : FontWeight.w700)),
                                  ),
                                  if (!n.isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                          color: AppColors.teal,
                                          shape: BoxShape.circle),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(n.body,
                                  style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 13,
                                      height: 1.4)),
                              const SizedBox(height: 4),
                              Text(n.time,
                                  style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
