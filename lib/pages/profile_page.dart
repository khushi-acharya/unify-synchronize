import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import '../models/mock_data.dart';
import '../widgets/common_widgets.dart';
import 'edit_profile_page.dart';
import 'new_project_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  final bool standalone;
  const ProfilePage({super.key, this.standalone = true});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _tabIndex = 0;
  final _tabs = ['All Projects', 'Case Studies', 'Drafts'];
  final _data = MockDataService();

  List<PortfolioItem> get _filteredItems {
    final all = _data.portfolioItems;
    switch (_tabIndex) {
      case 1:
        return all.where((i) => i.tag != null).toList();
      case 2:
        return [];
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildStatsRow(),
                    const SizedBox(height: 20),
                    _buildPortfolioHeader(),
                    const SizedBox(height: 16),
                    _buildTabBar(),
                    const SizedBox(height: 16),
                    _buildPortfolioGrid(),
                    const SizedBox(height: 20),
                    _buildRecentActivity(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        color: AppColors.teal,
                        borderRadius: BorderRadius.circular(6)),
                    child: const Icon(Icons.hub, color: Colors.black, size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text('Synchronise',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800)),
                ],
              ),
              // FIXED: Settings icon is now a proper tappable button
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsPage())),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.settings_outlined,
                      color: AppColors.textMuted, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.teal, Color(0xFF6B7ADE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _data.currentUser.isAvailable
                            ? AppColors.activeGreen
                            : AppColors.idleOrange,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.card, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_data.currentUser.name,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3)),
                    const SizedBox(height: 2),
                    Text(_data.currentUser.title.toUpperCase(),
                        style: const TextStyle(
                            color: AppColors.teal,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1)),
                    const SizedBox(height: 6),
                    Text(
                      _data.currentUser.bio,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  // FIXED: Share Profile now copies link to clipboard
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(
                        text: 'https://synchronise.app/alex-sterling'));
                    showAppSnackbar(context, 'Profile link copied!',
                        icon: Icons.check_circle_outline);
                  },
                  icon: const Icon(Icons.share, size: 14),
                  label: const Text('SHARE PROFILE',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  // FIXED: Edit Details now navigates to EditProfilePage
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EditProfilePage())),
                  icon: const Icon(Icons.edit,
                      size: 14, color: AppColors.textSecondary),
                  label: const Text('EDIT DETAILS',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: AppColors.textSecondary)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.auto_awesome, color: AppColors.teal, size: 14),
                  SizedBox(width: 6),
                  Text('Skillset',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _data.currentUser.skills
                    .map((s) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.tealBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.teal.withOpacity(0.3)),
                          ),
                          child: Text(s,
                              style: const TextStyle(
                                  color: AppColors.teal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _statChip('${_data.currentUser.followersCount}', 'Followers'),
        const SizedBox(width: 10),
        _statChip('${_data.currentUser.followingCount}', 'Following'),
        const SizedBox(width: 10),
        _statChip('${_data.currentUser.projectsCount}', 'Projects'),
      ],
    );
  }

  Widget _statChip(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Portfolio',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3)),
            SizedBox(height: 4),
            Text('Curated creative collaborations.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
          ],
        ),
        // Add Project button navigates to NewProjectPage and refreshes on return
        GestureDetector(
          onTap: () async {
            final added = await Navigator.push<bool>(
                context, MaterialPageRoute(builder: (_) => const NewProjectPage()));
            if (added == true && mounted) {
              setState(() {});
              showAppSnackbar(context, 'Project added to your portfolio!',
                  icon: Icons.check_circle_outline);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.teal,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: const [
                Icon(Icons.add, color: Colors.black, size: 16),
                SizedBox(width: 4),
                Text('Add Project',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Row(
      children: List.generate(_tabs.length, (i) {
        final selected = i == _tabIndex;
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () => setState(() => _tabIndex = i),
            child: Column(
              children: [
                Text(
                  _tabs[i],
                  style: TextStyle(
                    color: selected ? AppColors.textPrimary : AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                if (selected)
                  Container(
                    height: 2,
                    width: _tabs[i].length * 7.0,
                    color: AppColors.teal,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPortfolioGrid() {
    final items = _filteredItems;
    if (items.isEmpty && _tabIndex == 2) {
      return Container(
        height: 140,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.inbox_outlined, color: AppColors.textMuted, size: 32),
            SizedBox(height: 8),
            Text('No drafts yet',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
          ],
        ),
      );
    }
    return Column(
      children: [
        ...items.map((item) => _buildPortfolioCard(item)).toList(),
        _buildAddProjectCard(),
      ],
    );
  }

  Widget _buildPortfolioCard(PortfolioItem item) {
    return GestureDetector(
      onTap: () => showAppSnackbar(context, 'Opening ${item.title}...',
          icon: Icons.open_in_new),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: item.cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                      child: Icon(item.icon,
                          size: 48,
                          color: AppColors.teal.withOpacity(0.25))),
                  if (item.tag != null)
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
                        child: Text(item.tag!,
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
                  Text(item.title,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(item.description,
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          height: 1.5)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.date,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 11)),
                      Row(
                        children: [
                          if (item.likes != null) ...[
                            const Icon(Icons.favorite_outline,
                                color: AppColors.textMuted, size: 14),
                            const SizedBox(width: 4),
                            Text('${item.likes}',
                                style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12)),
                            const SizedBox(width: 12),
                          ],
                          const Icon(Icons.arrow_forward,
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

  Widget _buildAddProjectCard() {
    return GestureDetector(
      onTap: () async {
        final added = await Navigator.push<bool>(
            context, MaterialPageRoute(builder: (_) => const NewProjectPage()));
        if (added == true && mounted) {
          setState(() {});
          showAppSnackbar(context, 'Project added to your portfolio!',
              icon: Icons.check_circle_outline);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppColors.teal.withOpacity(0.4),
              style: BorderStyle.solid,
              width: 1.5),
          color: AppColors.tealBg.withOpacity(0.3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_circle_outline, color: AppColors.teal, size: 28),
            SizedBox(height: 8),
            Text('Add Project',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('Share your latest masterpiece.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
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
              const Text('Recent Activity',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
              TextButton(
                onPressed: () =>
                    showAppSnackbar(context, 'Full activity log coming soon!'),
                child: const Text('View All',
                    style: TextStyle(color: AppColors.teal, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActivityItem(Icons.comment_outlined, 'Yesterday',
              'Commented on ', '"Fluid Dynamics Branding"', ' by Jordan Reed.'),
          const Divider(color: AppColors.border, height: 20),
          _buildActivityItem(Icons.group_add_outlined, 'Oct 24, 2023',
              'Joined the ', 'Web Accessibility Guild', ' as a Founding Member.'),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      IconData icon, String date, String pre, String highlight, String post) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.textMuted, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11)),
              const SizedBox(height: 2),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 13, height: 1.4),
                  children: [
                    TextSpan(
                        text: pre,
                        style:
                            const TextStyle(color: AppColors.textSecondary)),
                    TextSpan(
                        text: highlight,
                        style: const TextStyle(
                            color: AppColors.teal,
                            fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: post,
                        style:
                            const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
