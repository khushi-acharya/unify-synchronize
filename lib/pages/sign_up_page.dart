import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  bool _agreeTerms = false;

  int _roleIndex = 0;
  final _roles = ['Designer', 'Developer', 'Artist', 'Musician', 'Writer', 'Other'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      showAppSnackbar(context, 'Please agree to the Terms of Service',
          color: AppColors.orange, icon: Icons.warning_outlined);
      return;
    }
    
    if (_passCtrl.text != _confirmCtrl.text) {
      showAppSnackbar(context, 'Passwords do not match',
          color: AppColors.orange, icon: Icons.warning_outlined);
      return;
    }
    
    setState(() => _loading = true);
    
    try {
      await AuthService().signUp(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context,
          e.toString().replaceAll('Exception: ', ''),
          color: AppColors.orange,
          icon: Icons.error_outline,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.hub, color: Colors.black, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('Synchronise', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Create account', style: TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                const SizedBox(height: 6),
                const Text('Join the creative collaboration platform.', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                const SizedBox(height: 32),

                const TealLabel('FULL NAME'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                  decoration: _inputDeco('Alex Sterling', null),
                ),
                const SizedBox(height: 20),

                const TealLabel('EMAIL'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                  decoration: _inputDeco('you@example.com', null),
                ),
                const SizedBox(height: 20),

                const TealLabel('I AM A'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_roles.length, (i) {
                    final sel = i == _roleIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _roleIndex = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? AppColors.teal : AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: sel ? AppColors.teal : AppColors.border),
                        ),
                        child: Text(
                          _roles[i],
                          style: TextStyle(
                            color: sel ? Colors.black : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                const TealLabel('PASSWORD'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscurePass,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 8) return 'At least 8 characters';
                    return null;
                  },
                  decoration: _inputDeco('••••••••', IconButton(
                    icon: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textMuted, size: 20),
                    onPressed: () => setState(() => _obscurePass = !_obscurePass),
                  )),
                ),
                const SizedBox(height: 20),

                const TealLabel('CONFIRM PASSWORD'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscureConfirm,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please confirm password';
                    if (v != _passCtrl.text) return 'Passwords do not match';
                    return null;
                  },
                  decoration: _inputDeco('••••••••', IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textMuted, size: 20),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  )),
                ),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _agreeTerms,
                        onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                        activeColor: AppColors.teal,
                        checkColor: Colors.black,
                        side: const BorderSide(color: AppColors.border, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.4),
                          children: [
                            TextSpan(text: 'I agree to the '),
                            TextSpan(text: 'Terms of Service', style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.w600)),
                            TextSpan(text: ' and '),
                            TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                PrimaryButton(
                  label: 'Create Account',
                  onPressed: _signUp,
                  isLoading: _loading,
                  color: AppColors.orange,
                  height: 52,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('Sign in', style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint, Widget? suffix) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.textMuted),
    filled: true,
    fillColor: AppColors.card,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.teal, width: 1.5)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    suffixIcon: suffix,
    errorStyle: const TextStyle(color: Color(0xFFEF4444), fontSize: 12),
  );
}
