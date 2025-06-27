import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_kurir_app/util/session_manager.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();

    _handleSplash();
  }

  Future<void> _handleSplash() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    final isOnboarding = await SessionManager.isOnboardingShown();
    if (!mounted) return;
    if (!isOnboarding) {
      context.go('/onboarding');
    } else {
      // Cek session login
      final valid = await SessionManager.isSessionValid();
      if (!mounted) return;
      if (valid) {
        final role = await SessionManager.getRole();
        if (role == 'courier') {
          if (!mounted) return;
          context.go('/kurir-home');
        } else {
          if (!mounted) return;
          context.go('/home');
        }
      } else {
        context.go('/login');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [const Color(0xFF667eea), const Color(0xFF764ba2)]
                : [const Color(0xFF4A80F0), const Color(0xFF7B68EE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withAlpha(90),
                              Colors.white.withAlpha(27),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(16),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(22),
                        child: const ImageIcon(
                          AssetImage('assets/ic_transparent_bg.png'),
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'KurirAtapange',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withAlpha(240),
                        letterSpacing: 2.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kirim barang mudah & cepat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withAlpha(180),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 28),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDarkMode ? const Color(0xFF667eea) : Colors.white,
                      ),
                      backgroundColor: Colors.white.withAlpha(50),
                      strokeWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
