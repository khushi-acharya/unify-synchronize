import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/mock_data.dart';
import '../widgets/common_widgets.dart';

class NewProjectPage extends StatefulWidget {
  const NewProjectPage({super.key});

  @override
  State<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  int _categoryIndex = 0;
  bool _loading = false;
  final List<String> _addedRoles = [];

  final _categories = ['Art', 'Games', 'Music', 'Apps', 'Other'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _roleCtrl.dispose();
    super.dispose();
  }

  void _addRole() {
    if (_roleCtrl.text.trim().isEmpty) return;
    setState(() {
      _addedRoles.add(_roleCtrl.text.trim());
      _roleCtrl.clear();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      // Save the new project into the singleton data service
      MockDataService().addMyProject(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _categories[_categoryIndex],
        openRoles: List.from(_addedRoles),
      );
      setState(() => _loading = false);
      // Pop with true so the caller knows to refresh
      Navigator.pop(context, true);
    }
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
        title: const Text('New Project',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const TealLabel('PROJECT TITLE'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleCtrl,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 14),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Title is required' : null,
              decoration: _inputDeco('e.g. Neo-Surrealist Gallery'),
            ),
            const SizedBox(height: 20),

            const TealLabel('CATEGORY'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_categories.length, (i) {
                final sel = i == _categoryIndex;
                return GestureDetector(
                  onTap: () => setState(() => _categoryIndex = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.teal : AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color:
                              sel ? AppColors.teal : AppColors.border),
                    ),
                    child: Text(_categories[i],
                        style: TextStyle(
                            color: sel
                                ? Colors.black
                                : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: sel
                                ? FontWeight.w700
                                : FontWeight.w500)),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            const TealLabel('DESCRIPTION'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              maxLines: 4,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 14),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Description is required' : null,
              decoration: _inputDeco(
                  'Describe your project, goals, and what you\'re building...'),
            ),
            const SizedBox(height: 20),

            const TealLabel('OPEN ROLES'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _roleCtrl,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14),
                    onFieldSubmitted: (_) => _addRole(),
                    decoration:
                        _inputDeco('e.g. 3D Artist, Sound Designer'),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _addRole,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add,
                        color: Colors.black, size: 22),
                  ),
                ),
              ],
            ),
            if (_addedRoles.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _addedRoles
                    .map((role) => Container(
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
                              Text(role,
                                  style: const TextStyle(
                                      color: AppColors.teal,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => setState(
                                    () => _addedRoles.remove(role)),
                                child: const Icon(Icons.close,
                                    color: AppColors.teal, size: 14),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Create Project',
              onPressed: _submit,
              isLoading: _loading,
              height: 52,
              icon: Icons.rocket_launch_outlined,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
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
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        errorStyle:
            const TextStyle(color: Color(0xFFEF4444), fontSize: 12),
      );
}
