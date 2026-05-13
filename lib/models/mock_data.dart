import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

// ─── Models ──────────────────────────────────────────────────────────────────

class UserProfile {
  final String id;
  final String name;
  final String title;
  final String bio;
  final String location;
  final String website;
  final List<String> skills;
  final int followersCount;
  final int followingCount;
  final int projectsCount;
  bool isAvailable;

  UserProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.bio,
    required this.location,
    required this.website,
    required this.skills,
    required this.followersCount,
    required this.followingCount,
    required this.projectsCount,
    required this.isAvailable,
  });
}

class Project {
  final String id;
  final String category;
  final String title;
  final String description;
  final double progress;
  final String progressLabel;
  final int membersCount;
  final Color cardColor;
  final IconData icon;
  final String status;
  final String dueDate;
  final List<String> openRoles;
  bool isFavorited;

  Project({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.progress,
    required this.progressLabel,
    required this.membersCount,
    required this.cardColor,
    required this.icon,
    required this.status,
    required this.dueDate,
    required this.openRoles,
    this.isFavorited = false,
  });
}

class Application {
  final String id;
  final String role;
  final String projectName;
  final String status;
  final Color statusColor;
  final String appliedDate;
  final String applicantEmail;
  final String applicantName;

  Application({
    required this.id,
    required this.role,
    required this.projectName,
    required this.status,
    required this.statusColor,
    required this.appliedDate,
    this.applicantEmail = '',
    this.applicantName = '',
  });
}

class PortfolioItem {
  final String id;
  final String title;
  final String description;
  final String? tag;
  final int? likes;
  final String date;
  final IconData icon;
  final Color cardColor;
  bool isLiked;

  PortfolioItem({
    required this.id,
    required this.title,
    required this.description,
    this.tag,
    this.likes,
    required this.date,
    required this.icon,
    required this.cardColor,
    this.isLiked = false,
  });
}

class ActivityItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color dotColor;

  ActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.dotColor,
  });
}

class Notification {
  final String id;
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color iconColor;
  bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
  });
}

// ─── Mock Data Service ────────────────────────────────────────────────────────

class MockDataService {
  // Singleton
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Current user
  UserProfile currentUser = UserProfile(
    id: 'u1',
    name: 'Alex Sterling',
    title: 'Senior UI/UX Architect',
    bio: 'Passionate about crafting human-centered digital experiences. Building at the intersection of design systems and emerging tech.',
    location: 'San Francisco, CA',
    website: 'alexsterling.design',
    skills: ['UI Architecture', 'React Flow', 'Design Ops', 'Micro-interactions', 'TypeScript', 'Accessibility', 'Figma', 'Motion Design'],
    followersCount: 1284,
    followingCount: 342,
    projectsCount: 8,
    isAvailable: true,
  );

  // Projects
  final List<Project> projects = [
    Project(
      id: 'p1',
      category: 'ART',
      title: 'Neo-Surrealist Gallery',
      description: 'Creating an immersive VR exhibition space for digital art and surrealist installations.',
      progress: 0.65,
      progressLabel: 'Development Progress',
      membersCount: 4,
      cardColor: const Color(0xFF0D3D38),
      icon: Icons.palette_outlined,
      status: 'ACTIVE',
      dueDate: 'Jun 30, 2025',
      openRoles: ['3D Artist', 'Sound Designer'],
    ),
    Project(
      id: 'p2',
      category: 'GAMES',
      title: 'Echoes of Orion',
      description: 'A story-driven sci-fi RPG focused on atmospheric world building and exploration.',
      progress: 0.40,
      progressLabel: 'Pre-alpha Phase',
      membersCount: 1,
      cardColor: const Color(0xFF1A2035),
      icon: Icons.sports_esports_outlined,
      status: 'ACTIVE',
      dueDate: 'Dec 01, 2025',
      openRoles: ['Narrative Writer', 'Concept Artist', 'Game Dev'],
    ),
    Project(
      id: 'p3',
      category: 'MUSIC',
      title: 'Sonic Synthesis',
      description: 'Collaborative open-source library for generative synthesis and sound design tools.',
      progress: 0.85,
      progressLabel: 'Composition Phase',
      membersCount: 2,
      cardColor: const Color(0xFF1A1535),
      icon: Icons.music_note_outlined,
      status: 'IDLE',
      dueDate: 'May 15, 2025',
      openRoles: ['Frontend Dev'],
    ),
    Project(
      id: 'p4',
      category: 'APPS',
      title: 'FinTech Revolution',
      description: 'Next-gen personal finance platform with AI-driven insights and budget automation.',
      progress: 0.30,
      progressLabel: 'MVP Phase',
      membersCount: 3,
      cardColor: const Color(0xFF1A2520),
      icon: Icons.account_balance_outlined,
      status: 'ACTIVE',
      dueDate: 'Aug 20, 2025',
      openRoles: ['Senior UX', 'Backend Dev', 'Data Scientist'],
    ),
    Project(
      id: 'p5',
      category: 'ART',
      title: 'Metaverse Spaces',
      description: 'Designing immersive 3D environments for virtual collaboration and social interaction.',
      progress: 0.55,
      progressLabel: 'Design Phase',
      membersCount: 2,
      cardColor: const Color(0xFF2A1535),
      icon: Icons.view_in_ar_outlined,
      status: 'PENDING',
      dueDate: 'Sep 10, 2025',
      openRoles: ['3D Generalist', 'UX Designer'],
    ),
    Project(
      id: 'p6',
      category: 'APPS',
      title: 'EduFlow Platform',
      description: 'A next-generation e-learning platform with adaptive curricula and AI-powered mentoring.',
      progress: 0.20,
      progressLabel: 'Ideation Phase',
      membersCount: 2,
      cardColor: const Color(0xFF1A2035),
      icon: Icons.school_outlined,
      status: 'ACTIVE',
      dueDate: 'Oct 01, 2025',
      openRoles: ['Product Designer', 'ML Engineer'],
    ),
  ];

  // My active projects (mutable so new projects can be added)
  final List<Map<String, dynamic>> myProjects = [
    {
      'title': 'Neo-Brutalism UI Kit',
      'role': 'Lead Visual Designer',
      'status': 'ACTIVE',
      'statusColor': AppColors.activeGreen,
      'icon': Icons.brush_outlined,
      'members': ['JD', 'AS', '+2'],
      'progress': 0.85,
    },
    {
      'title': 'Brand Motion Reel',
      'role': 'Motion Specialist',
      'status': 'IDLE',
      'statusColor': AppColors.idleOrange,
      'icon': Icons.play_circle_outline,
      'members': ['RK', '+1'],
      'progress': 0.42,
    },
    {
      'title': 'Webflow Dev Hand-off',
      'role': 'Tech Lead',
      'status': 'PENDING',
      'statusColor': AppColors.pendingGray,
      'icon': Icons.edit_outlined,
      'members': [],
      'progress': 0.15,
    },
  ];

  // Add a new project to both myProjects and portfolioItems
  void addMyProject({
    required String title,
    required String description,
    required String category,
    required List<String> openRoles,
  }) {
    final iconMap = {
      'Art': Icons.palette_outlined,
      'Games': Icons.sports_esports_outlined,
      'Music': Icons.music_note_outlined,
      'Apps': Icons.phone_android_outlined,
      'Other': Icons.folder_outlined,
    };
    final colorMap = {
      'Art': const Color(0xFF0D3D30),
      'Games': const Color(0xFF1A2035),
      'Music': const Color(0xFF1A1535),
      'Apps': const Color(0xFF1A2520),
      'Other': const Color(0xFF2A1535),
    };
    final id = 'p_${DateTime.now().millisecondsSinceEpoch}';

    // Add to dashboard list
    myProjects.add({
      'title': title,
      'role': 'Creator',
      'status': 'ACTIVE',
      'statusColor': AppColors.activeGreen,
      'icon': iconMap[category] ?? Icons.folder_outlined,
      'members': [],
      'progress': 0.0,
    });

    // Add to explore projects list
    projects.add(Project(
      id: id,
      category: category.toUpperCase(),
      title: title,
      description: description,
      progress: 0.0,
      progressLabel: 'Just started',
      membersCount: 1,
      cardColor: colorMap[category] ?? const Color(0xFF2A1535),
      icon: iconMap[category] ?? Icons.folder_outlined,
      status: 'ACTIVE',
      dueDate: 'TBD',
      openRoles: openRoles,
    ));

    // Add to portfolio
    portfolioItems.add(PortfolioItem(
      id: id,
      title: title,
      description: description.isEmpty ? 'A new $category project.' : description,
      date: _formatDate(DateTime.now()),
      icon: iconMap[category] ?? Icons.folder_outlined,
      cardColor: colorMap[category] ?? const Color(0xFF2A1535),
    ));

    // Update user project count
    currentUser = UserProfile(
      id: currentUser.id,
      name: currentUser.name,
      title: currentUser.title,
      bio: currentUser.bio,
      location: currentUser.location,
      website: currentUser.website,
      skills: currentUser.skills,
      followersCount: currentUser.followersCount,
      followingCount: currentUser.followingCount,
      projectsCount: currentUser.projectsCount + 1,
      isAvailable: currentUser.isAvailable,
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[d.month - 1]} ${d.year}';
  }

  // Applications
  final List<Application> applications = [
    Application(
      id: 'a1',
      role: 'Senior UX Arch.',
      projectName: 'FinTech Revolution',
      status: 'REVIEWING',
      statusColor: const Color(0xFF2563EB),
      appliedDate: 'May 1, 2025',
    ),
    Application(
      id: 'a2',
      role: '3D Artist',
      projectName: 'Metaverse Spaces',
      status: 'APPLIED',
      statusColor: AppColors.teal,
      appliedDate: 'Apr 28, 2025',
    ),
    Application(
      id: 'a3',
      role: 'Sound Designer',
      projectName: 'Neo-Surrealist Gallery',
      status: 'REJECTED',
      statusColor: const Color(0xFFEF4444),
      appliedDate: 'Apr 15, 2025',
    ),
    Application(
      id: 'a4',
      role: 'Frontend Dev',
      projectName: 'Sonic Synthesis',
      status: 'ACCEPTED',
      statusColor: AppColors.activeGreen,
      appliedDate: 'Mar 30, 2025',
    ),
  ];

  // Portfolio items
  final List<PortfolioItem> portfolioItems = [
    PortfolioItem(
      id: 'po1',
      title: 'Veridia Ecosystem',
      description: 'A multi-platform design system for a sustainable energy monitoring hub, serving over 10k users.',
      tag: 'FEATURED CASE STUDY',
      likes: null,
      date: 'Mar 2024',
      icon: Icons.eco_outlined,
      cardColor: const Color(0xFF0D3D30),
    ),
    PortfolioItem(
      id: 'po2',
      title: 'Nexus Dash',
      description: 'Real-time collaboration analytics for remote-first creative agencies.',
      likes: 412,
      date: 'Jan 2024',
      icon: Icons.analytics_outlined,
      cardColor: const Color(0xFF0D2535),
    ),
    PortfolioItem(
      id: 'po3',
      title: 'Palette Gen Pro',
      description: 'AI-driven color theory assistant for digital illustrators and UI designers.',
      date: 'Nov 2023',
      icon: Icons.color_lens_outlined,
      cardColor: const Color(0xFF2D1535),
    ),
  ];

  // Activities (shared)
  final List<ActivityItem> recentActivities = [
    ActivityItem(
      id: 'act1',
      title: 'Sarah left a comment',
      subtitle: '"Love the new color tokens!"',
      time: '2 hours ago',
      icon: Icons.comment_outlined,
      dotColor: AppColors.teal,
    ),
    ActivityItem(
      id: 'act2',
      title: 'New Milestone reached',
      subtitle: 'Wireframes approved by client',
      time: 'Yesterday',
      icon: Icons.emoji_events_outlined,
      dotColor: AppColors.activeGreen,
    ),
    ActivityItem(
      id: 'act3',
      title: 'Jordan Reed applied to your project',
      subtitle: 'Applied for 3D Artist — Metaverse Spaces',
      time: '2 days ago',
      icon: Icons.person_add_outlined,
      dotColor: AppColors.purple,
    ),
    ActivityItem(
      id: 'act4',
      title: 'New message from Aria Kim',
      subtitle: '"Can we sync on the motion specs tomorrow?"',
      time: '3 days ago',
      icon: Icons.message_outlined,
      dotColor: AppColors.orange,
    ),
  ];

  // Notifications
  final List<Notification> notifications = [
    Notification(
      id: 'n1',
      title: 'Application update',
      body: 'FinTech Revolution is reviewing your application.',
      time: '1h ago',
      icon: Icons.work_outline,
      iconColor: const Color(0xFF2563EB),
    ),
    Notification(
      id: 'n2',
      title: 'New comment',
      body: 'Sarah commented on Neo-Brutalism UI Kit.',
      time: '3h ago',
      icon: Icons.comment_outlined,
      iconColor: AppColors.teal,
    ),
    Notification(
      id: 'n3',
      title: 'Milestone reached',
      body: 'Your team completed Sprint 3 of 4!',
      time: 'Yesterday',
      icon: Icons.flag_outlined,
      iconColor: AppColors.activeGreen,
    ),
    Notification(
      id: 'n4',
      title: 'New follower',
      body: 'Jordan Reed started following you.',
      time: '2d ago',
      icon: Icons.person_add_outlined,
      iconColor: AppColors.purple,
    ),
    Notification(
      id: 'n5',
      title: 'Weekly digest',
      body: '5 new projects match your skills this week.',
      time: '3d ago',
      icon: Icons.bar_chart_outlined,
      iconColor: AppColors.orange,
    ),
  ];

  // Filtered explore projects
  List<Project> filterProjects(String category, String query) {
    return projects.where((p) {
      final matchCat = category == 'All Projects' || p.category == category.toUpperCase();
      final matchQ = query.isEmpty ||
          p.title.toLowerCase().contains(query.toLowerCase()) ||
          p.description.toLowerCase().contains(query.toLowerCase()) ||
          p.category.toLowerCase().contains(query.toLowerCase());
      return matchCat && matchQ;
    }).toList();
  }

  int get unreadNotificationCount =>
      notifications.where((n) => !n.isRead).length;
}
