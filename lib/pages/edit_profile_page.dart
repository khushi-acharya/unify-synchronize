import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/mock_data.dart';
import '../widgets/common_widgets.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _data = MockDataService();
  late final _nameCtrl = TextEditingController(text: _data.currentUser.name);
  late final _titleCtrl = TextEditingController(text: _data.currentUser.title);
  late final _bioCtrl = TextEditingController(text: _data.currentUser.bio);
  late final _locationCtrl = TextEditingController(text: _data.currentUser.location);
  late final _websiteCtrl = TextEditingController(text: _data.currentUser.website);
  late List<String> _skills = List.from(_data.currentUser.skills);
  late bool _isAvailable = _data.currentUser.isAvailable;
  bool _loading = false;
  final _newSkillCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _titleCtrl.dispose();
    _bioCtrl.dispose();
    _locationCtrl.dispose();
    _websiteCtrl.dispose();
    _newSkillCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      // In a real app, update the service/state here
      _data.currentUser.isAvailable = _isAvailable;
      setState(() => _loading = false);
      Navigator.pop(context);
      showAppSnackbar(context, 'Profile updated!',
          icon: Icons.check_circle_outline);
    }
  }

  void _addSkill() {
    final s = _newSkillCtrl.text.trim();
    if (s.isEmpty || _skills.contains(s)) return;
    setState(() {
      _skills.add(s);
      _newSkillCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: _loading ? null : _save,
            child: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: AppColors.teal, strokeWidth: 2))
                : const Text('Save',
                    style: TextStyle(
                        color: AppColors.teal,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Avatar placeholder
          Center(
            child: Stack(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.teal, AppColors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.person,
                      color: Colors.white, size: 48),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => showAppSnackbar(
                        context, 'Image upload coming soon!',
                        icon: Icons.photo_camera_outlined),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.teal,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.background, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt,
                          color: Colors.black, size: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          _field('FULL NAME', _nameCtrl, 'Your name'),
          const SizedBox(height: 16),
          _field('TITLE / ROLE', _titleCtrl, 'e.g. Senior UI/UX Architect'),
          const SizedBox(height: 16),
          _field('BIO', _bioCtrl, 'Tell collaborators about yourself...',
              maxLines: 4),
          const SizedBox(height: 16),
          _field('LOCATION', _locationCtrl, 'e.g. San Francisco, CA'),
          const SizedBox(height: 16),
          _field('WEBSITE', _websiteCtrl, 'yoursite.com'),
          const SizedBox(height: 24),

          // Availability toggle
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Available for Projects',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 3),
                      Text('Show collaborators you\'re open to new work.',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                Switch(
                  value: _isAvailable,
                  onChanged: (v) => setState(() => _isAvailable = v),
                  activeColor: AppColors.teal,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Skills
          const TealLabel('SKILLS'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._skills.map((s) => GestureDetector(
                    onLongPress: () =>
                        setState(() => _skills.remove(s)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.tealBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.teal.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(s,
                              style: const TextStyle(
                                  color: AppColors.teal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(width: 6),
                          const Icon(Icons.close,
                              color: AppColors.teal, size: 13),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newSkillCtrl,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 14),
                  onSubmitted: (_) => _addSkill(),
                  decoration: InputDecoration(
                    hintText: 'Add a skill...',
                    hintStyle:
                        const TextStyle(color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.card,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.border)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.teal, width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _addSkill,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add, color: Colors.black, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'Save Changes',
            onPressed: _save,
            isLoading: _loading,
            height: 52,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TealLabel(label),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          style: const TextStyle(
              color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: AppColors.teal, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
