import 'package:flutter/material.dart';
import '../services/project_service.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../models/mock_data.dart';
import '../widgets/common_widgets.dart';
import 'firestore_project_detail_page.dart';
import 'notifications_page.dart';
import 'new_project_page.dart';

class ExplorePage extends StatefulWidget {
  final bool standalone;
  const ExplorePage({super.key, this.standalone = true});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int _selectedCategory = 0;
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  bool _showFavoritesOnly = false;

  final _categories = ['All', 'Art', 'Games', 'Music', 'Apps'];

  List<FirestoreProject> _filterProjects(List<FirestoreProject> projects) {
    final cat = _categories[_selectedCategory];
    var list = projects;
    
    if (cat != 'All') {
      list = list.where((p) => p.category.toLowerCase() == cat.toLowerCase()).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      list = list.where((p) => 
        p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        p.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return list;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _toggleFavorite(Project project) {
    setState(() => project.isFavorited = !project.isFavorited);
    showAppSnackbar(
      context,
      project.isFavorited ? 'Added to favorites' : 'Removed from favorites',
      icon: project.isFavorited ? Icons.bookmark : Icons.bookmark_border,
    );
  }

  void _openProject(FirestoreProject project) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => FirestoreProjectDetailPage(project: project)),
    ).then((_) => setState(() {}));
  }

  void _showSortFilter() {
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
            const Text('Filter & Sort',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            const Text('SHOW',
                style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8)),
            const SizedBox(height: 10),
            _filterOption(ctx, 'All Projects', !_showFavoritesOnly, () {
              setState(() => _showFavoritesOnly = false);
              Navigator.pop(ctx);
            }),
            const SizedBox(height: 8),
            _filterOption(ctx, 'Favorites Only', _showFavoritesOnly, () {
              setState(() => _showFavoritesOnly = true);
              Navigator.pop(ctx);
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _filterOption(
      BuildContext ctx, String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.tealBg : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected
                  ? AppColors.teal.withOpacity(0.5)
                  : AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: selected
                          ? AppColors.teal
                          : AppColors.textSecondary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 14)),
            ),
            if (selected)
              const Icon(Icons.check, color: AppColors.teal, size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = AuthService().getCurrentUser()?.uid;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryTabs(),
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
                  final filtered = _filterProjects(allProjects);

                  if (filtered.isEmpty) {
                    return EmptyState(
                      icon: Icons.search_off,
                      title: 'No projects found',
                      subtitle: 'Try a different search or category.',
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.teal,
                    backgroundColor: AppColors.card,
                    onRefresh: () async =>
                        await Future.delayed(const Duration(seconds: 1)),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: filtered.length,
                      itemBuilder: (context, i) =>
                          _buildProjectCard(filtered[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const NewProjectPage())),
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    final unread = 0; // Notifications feature coming soon
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Discover your next',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5),
                ),
                Text(
                  'collaboration',
                  style: TextStyle(
                      color: AppColors.teal,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.tune, color: AppColors.textSecondary, size: 22),
                onPressed: _showSortFilter,
                tooltip: 'Filter',
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
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: TextField(
        controller: _searchCtrl,
        style:
            const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Search projects, roles, categories...',
          hintStyle: const TextStyle(color: AppColors.textMuted),
          prefixIcon:
              const Icon(Icons.search, color: AppColors.textMuted, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close,
                      color: AppColors.textMuted, size: 18),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.card,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.teal, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: SizedBox(
        height: 38,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _categories.length,
          itemBuilder: (context, i) {
            final selected = i == _selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () =>
                    setState(() => _selectedCategory = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.teal : AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: selected
                            ? AppColors.teal
                            : AppColors.border),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _categories[i],
                    style: TextStyle(
                      color: selected
                          ? Colors.black
                          : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Center(
                  child: Icon(icon,
                      size: 56,
                      color: AppColors.teal.withOpacity(0.3)),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    project.category.toUpperCase(),
                    style: const TextStyle(
                        color: AppColors.teal,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(project.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        height: 1.5)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.work_outline,
                        color: AppColors.textMuted, size: 13),
                    const SizedBox(width: 5),
                    Text(
                        '${project.openRoles.length} open role${project.openRoles.length != 1 ? 's' : ''}',
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
                if (project.ownerName != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'by ${project.ownerName}',
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => _openProject(project),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('View Project →',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
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
