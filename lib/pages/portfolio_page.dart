import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final AuthService _authService = AuthService();
  String _selectedTab = 'All Projects';

  void _handleLogout() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();
    final isMobile = MediaQuery.of(context).size.width < 1024;

    return Scaffold(
      backgroundColor: const Color(0xFF05161A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0a1f24),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF83d4d9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.hub,
                color: Color(0xFF003739),
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'CollabHub',
              style: TextStyle(
                color: Color(0xFFe0e3e3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Explore',
              style: TextStyle(color: Color(0xFF83d4d9)),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Dashboard',
              style: TextStyle(color: Color(0xFFe0e3e3)),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Profile',
              style: TextStyle(color: Color(0xFFe0e3e3)),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: _handleLogout,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF83d4d9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                color: Color(0xFF003739),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: isMobile ? _buildMobileLayout(user) : _buildDesktopLayout(user),
    );
  }

  Widget _buildMobileLayout(user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileSection(user),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(user) {
    return Row(
      children: [
        // Left Sidebar
        SizedBox(
          width: 250,
          child: Container(
            color: const Color(0xFF0a1f24),
            child: SingleChildScrollView(
              child: _buildProfileSection(user),
            ),
          ),
        ),
        // Divider
        Container(
          width: 1,
          color: const Color(0xFF1a3a40),
        ),
        // Main Content
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: _buildMainContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(user) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF83d4d9),
                  const Color(0xFF0F969C),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'AS',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: const Color(0xFF003739),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Name
          Text(
            'Alex Sterling',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFe0e3e3),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Title
          Text(
            'SENIOR UX ARCHITECT',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF83d4d9),
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Bio
          Text(
            'Passionate about crafting human-centered digital experiences that solve the gap between aesthetics and functionality. Based in San Francisco.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFFbec9c9),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Share Profile Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share),
              label: const Text('SHARE PROFILE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F969C),
                foregroundColor: const Color(0xFFe0e3e3),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Edit Details Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text('EDIT DETAILS'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF83d4d9),
                side: const BorderSide(color: Color(0xFF83d4d9)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Skillset Section
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Icon(
                  Icons.stars,
                  color: Color(0xFF83d4d9),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Skillset',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFe0e3e3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSkillTag('UI Architecture'),
              _buildSkillTag('React Flow'),
              _buildSkillTag('Design Ops'),
              _buildSkillTag('Micro-interactions'),
              _buildSkillTag('TypeScript'),
              _buildSkillTag('Accessibility'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F969C).withOpacity(0.2),
        border: Border.all(color: const Color(0xFF83d4d9)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: const Color(0xFF83d4d9),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Portfolio Header
        Text(
          'Portfolio',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: const Color(0xFFe0e3e3),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'A curated selection of recent creative collaborations.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFFbec9c9),
          ),
        ),
        const SizedBox(height: 24),
        // Filter Tabs
        Row(
          children: [
            _buildFilterTab('All Projects'),
            const SizedBox(width: 16),
            _buildFilterTab('Case Studies'),
            const SizedBox(width: 16),
            _buildFilterTab('Drafts'),
          ],
        ),
        const SizedBox(height: 32),
        // Projects Grid
        Column(
          children: [
            // First Row
            Row(
              children: [
                Expanded(
                  child: _buildProjectCard(
                    title: 'Veridia Ecosystem',
                    description:
                        'A multi-platform design system for a sustainable energy monitoring hub, serving a diverse ecosystem.',
                    featured: true,
                    image: '🌍',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildProjectCard(
                    title: 'Nexus Dash',
                    description:
                        'Real-time collaboration analytics for remote-first creative agencies.',
                    featured: false,
                    image: '📊',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Second Row
            Row(
              children: [
                Expanded(
                  child: _buildProjectCard(
                    title: 'Palette Gen Pro',
                    description:
                        'AI-driven color theory assistant for digital illustrators and UI designers.',
                    featured: false,
                    image: '🎨',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildAddProjectCard(),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 48),
        // Recent Activity
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFFe0e3e3),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(color: Color(0xFF83d4d9)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildActivityItem(
          'Yesterday',
          'Commented on "Fluid Dynamics Branding" by Jordan Reed.',
          Icons.comment,
        ),
        const SizedBox(height: 16),
        _buildActivityItem(
          'Oct 24, 2023',
          'Joined the Web Accessibility Guild as a Founding Member.',
          Icons.group_add,
        ),
      ],
    );
  }

  Widget _buildFilterTab(String label) {
    bool isSelected = _selectedTab == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF83d4d9).withOpacity(0.2)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color:
                  isSelected ? const Color(0xFF83d4d9) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isSelected
                ? const Color(0xFF83d4d9)
                : const Color(0xFFbec9c9),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard({
    required String title,
    required String description,
    required bool featured,
    required String image,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0a3a40),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1a5a60),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Area
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF072E33),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                image,
                style: const TextStyle(fontSize: 60),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (featured)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF83d4d9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'FEATURED CASE STUDY',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF003739),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFe0e3e3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFbec9c9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: const Color(0xFF83d4d9),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '412',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: const Color(0xFFbec9c9),
                              ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.link,
                      color: const Color(0xFF83d4d9),
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProjectCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0a3a40).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1a5a60),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF83d4d9).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Color(0xFF83d4d9),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Add Project',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFFe0e3e3),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share your latest masterpiece with the\ncommunity.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFFbec9c9),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String date, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0a3a40),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF83d4d9),
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF83d4d9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFe0e3e3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
