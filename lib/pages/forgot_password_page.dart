import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_emailController.text.isEmpty) {
      _showErrorDialog('Please enter your email');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.resetPassword(email: _emailController.text.trim());
      setState(() {
        _emailSent = true;
      });
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: const Color(0xFF072E33),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF05161A),
              const Color(0xFF0a3a3f),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 400,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF072E33),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF0c7075).withOpacity(0.2),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(32),
              child: _emailSent ? _buildSuccessView() : _buildFormView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reset Your Password',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFFe0e3e3),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFFbec9c9),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Email Address',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: const Color(0xFFbec9c9),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'name@university.edu',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF889393),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 16,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF3e4949),
                width: 2,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF0F969C),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFF272b2b),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFFe0e3e3),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0C7075),
                const Color(0xFF0F969C),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isLoading ? null : _handleResetPassword,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF002021),
                          ),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'SEND RESET LINK',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF002021),
                          letterSpacing: 0.8,
                        ),
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
            child: Text(
              'Back to Login',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFF83d4d9),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle,
          size: 64,
          color: Color(0xFF83d4d9),
        ),
        const SizedBox(height: 24),
        Text(
          'Password Reset Email Sent',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFFe0e3e3),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'We\'ve sent a password reset link to ${_emailController.text}. Please check your email and follow the instructions to reset your password.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFFbec9c9),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0C7075),
                const Color(0xFF0F969C),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Text(
                  'BACK TO LOGIN',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF002021),
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
