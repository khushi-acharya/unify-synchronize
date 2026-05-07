import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_emailController.text.isEmpty || 
        _passwordController.text.isEmpty || 
        _confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showErrorDialog('Password must be at least 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (userCredential != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/portfolio');
        }
      }
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
        title: const Text('Create Account'),
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
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: const Color(0xFF072E33),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF0c7075).withOpacity(0.2),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Join CollabHub',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFe0e3e3),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Create your account to start collaborating',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFbec9c9),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Email field
                  Text(
                    'Student Email',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFFbec9c9),
                    ),
                  ),
                  const SizedBox(height: 4),
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
                  const SizedBox(height: 24),
                  // Password field
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFFbec9c9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: '••••••••',
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
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        child: Icon(
                          _showPassword ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xFF889393),
                        ),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFe0e3e3),
                    ),
                    obscureText: !_showPassword,
                  ),
                  const SizedBox(height: 24),
                  // Confirm password field
                  Text(
                    'Confirm Password',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFFbec9c9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: '••••••••',
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
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                        child: Icon(
                          _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xFF889393),
                        ),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFe0e3e3),
                    ),
                    obscureText: !_showConfirmPassword,
                  ),
                  const SizedBox(height: 32),
                  // Sign up button
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
                        onTap: _isLoading ? null : _handleSignUp,
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
                                  'CREATE ACCOUNT',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                    color: const Color(0xFF002021),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Back to login link
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: const Color(0xFFbec9c9),
                          ),
                          children: [
                            TextSpan(
                              text: 'Log in',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                color: const Color(0xFF83d4d9),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
