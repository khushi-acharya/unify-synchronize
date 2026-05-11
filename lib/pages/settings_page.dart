import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/theme_notifier.dart';
import '../widgets/common_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailDigest = false;
  bool _applicationUpdates = true;
  bool _newMessages = true;
  bool _projectInvites = true;

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to log out?',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (_) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Log Out',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
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
        title: const Text('Settings',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader('NOTIFICATIONS'),
          _toggleTile('Push Notifications', 'Receive push alerts',
              Icons.notifications_outlined, _pushNotifications,
              (v) => setState(() => _pushNotifications = v)),
          _toggleTile('Email Digest', 'Weekly summary emails',
              Icons.email_outlined, _emailDigest,
              (v) => setState(() => _emailDigest = v)),
          _toggleTile('Application Updates', 'When your application status changes',
              Icons.send_outlined, _applicationUpdates,
              (v) => setState(() => _applicationUpdates = v)),
          _toggleTile('New Messages', 'Direct messages from collaborators',
              Icons.message_outlined, _newMessages,
              (v) => setState(() => _newMessages = v)),
          _toggleTile('Project Invites', 'When you\'re invited to a project',
              Icons.group_add_outlined, _projectInvites,
              (v) => setState(() => _projectInvites = v)),

          const SizedBox(height: 20),
          _sectionHeader('APPEARANCE'),
          _toggleTile('Dark Mode', 'Easier on the eyes at night',
              Icons.dark_mode_outlined, ThemeNotifier.instance.isDark,
              (v) => setState(() => ThemeNotifier.instance.setDark(v))),

          const SizedBox(height: 20),
          _sectionHeader('ACCOUNT'),
          _navTile('Privacy Settings', Icons.lock_outline, () =>
              showAppSnackbar(context, 'Privacy settings coming soon!')),
          _navTile('Blocked Users', Icons.block, () =>
              showAppSnackbar(context, 'Blocked users page coming soon!')),
          _navTile('Linked Accounts', Icons.link, () =>
              showAppSnackbar(context, 'Linked accounts coming soon!')),
          _navTile('Delete Account', Icons.delete_outline, () =>
              showAppSnackbar(context, 'Contact support to delete account.',
                  color: AppColors.orange),
              color: const Color(0xFFEF4444)),

          const SizedBox(height: 20),
          _sectionHeader('ABOUT'),
          _navTile('Terms of Service', Icons.description_outlined, () =>
              showAppSnackbar(context, 'Opening Terms of Service...')),
          _navTile('Privacy Policy', Icons.privacy_tip_outlined, () =>
              showAppSnackbar(context, 'Opening Privacy Policy...')),
          _navTile('App Version', Icons.info_outline, () {},
              trailing: const Text('1.0.0',
                  style: TextStyle(
                      color: AppColors.textMuted, fontSize: 13))),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Color(0xFFEF4444), size: 18),
              label: const Text('Log Out',
                  style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFEF4444)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4, left: 4),
      child: Text(label,
          style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8)),
    );
  }

  Widget _toggleTile(String title, String subtitle, IconData icon,
      bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.textMuted, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.teal,
          ),
        ],
      ),
    );
  }

  Widget _navTile(String title, IconData icon, VoidCallback onTap,
      {Color? color, Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(icon,
                    color: color ?? AppColors.textMuted, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title,
                      style: TextStyle(
                          color: color ?? AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ),
                trailing ??
                    Icon(Icons.arrow_forward_ios,
                        color: color ?? AppColors.textMuted, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
