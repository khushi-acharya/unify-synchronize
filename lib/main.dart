import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'pages/home_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/portfolio_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CollabHub | Creative Hub Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF83d4d9),
          secondary: const Color(0xFF6ad7dd),
          surface: const Color(0xFF101414),
          error: const Color(0xFFffb4ab),
          onPrimary: const Color(0xFF003739),
          onSecondary: const Color(0xFF003739),
          onSurface: const Color(0xFFe0e3e3),
        ),
        scaffoldBackgroundColor: const Color(0xFF05161A),
        fontFamily: 'Montserrat',
      ),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const PortfolioPage(),
        '/portfolio': (context) => const PortfolioPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/sign-up': (context) => const SignUpPage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    return StreamBuilder(
      stream: authService.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
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
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF83d4d9),
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const PortfolioPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _showPassword = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (userCredential != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        // Navigate to portfolio page - AuthWrapper will handle the redirect
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
    final isMobile = MediaQuery.of(context).size.width < 1024;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Decorative background elements
          Positioned(
            top: -screenSize.height * 0.1,
            right: -screenSize.width * 0.05,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF83d4d9).withOpacity(0.03),
              ),
            ),
          ),
          Positioned(
            bottom: -screenSize.height * 0.1,
            left: -screenSize.width * 0.05,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0c7075).withOpacity(0.05),
              ),
            ),
          ),
          // Main content
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 1200,
                  minHeight: 700,
                ),
                margin: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.04,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF072E33),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF0c7075).withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F969C).withOpacity(0.05),
                      blurRadius: 40,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: isMobile
                    ? _buildMobileLayout()
                    : _buildDesktopLayout(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left side - Branding with abstract design
        Expanded(
          child: Stack(
            children: [
              Container(
                color: const Color(0xFF0a3a3f),
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF0F969C),
                        const Color(0xFF0C7075),
                        const Color(0xFF051620),
                      ],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.screen,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1579783902614-e3fb5141b0cb?w=800&q=80',
                        ),
                        fit: BoxFit.cover,
                        opacity: 0.6,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF05161A).withOpacity(0.9),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 32,
                left: 32,
                right: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'CollabHub',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFFe0e3e3),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'The precision tool for modern creators. Immerse yourself in a state of creative flow with sophisticated collaboration tools.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFbec9c9),
                        height: 1.6,
                      ),
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Right side - Login form
        Expanded(
          child: _buildFormContent(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildFormContent(),
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mobile brand view
            Row(
              children: [
                const Icon(
                  Icons.hub,
                  color: Color(0xFF83d4d9),
                  size: 24,
                ),
                const SizedBox(width: 4),
                Text(
                  'CollabHub',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFFe0e3e3),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Heading
            Text(
              'Welcome back, Creator',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: const Color(0xFFe0e3e3),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Access your workspace and resume your projects.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFbec9c9),
              ),
            ),
            const SizedBox(height: 32),
            // Form
            _buildEmailField(),
            const SizedBox(height: 24),
            _buildPasswordField(),
            const SizedBox(height: 12),
            _buildRememberMeCheckbox(),
            const SizedBox(height: 24),
            _buildLoginButton(),
            const SizedBox(height: 32),
            // Sign up link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFbec9c9),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/sign-up');
                  },
                  child: Text(
                    'Sign up',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF83d4d9),
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 64),
            // Footer links
            Wrap(
              spacing: 24,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildFooterLink('Privacy Policy'),
                _buildFooterLink('Terms of Service'),
                _buildFooterLink('System Status'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFFbec9c9),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/forgot-password');
              },
              child: Text(
                'Forgot Password?',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF83d4d9),
                ),
              ),
            ),
          ],
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
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value ?? false;
            });
          },
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const Color(0xFF0c7075);
            }
            return const Color(0xFF272b2b);
          }),
          side: BorderSide(
            color: const Color(0xFF3e4949),
          ),
        ),
        Text(
          'Remember me for 30 days',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFFbec9c9),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
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
          onTap: _isLoading ? null : _handleLogin,
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
                    'LOG IN',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF002021),
                      letterSpacing: 0.8,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: const Color(0xFF889393),
        ),
      ),
    );
  }
}
