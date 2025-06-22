import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/glass_container.dart';
import '../../models/onboarding_model.dart';
import '../../data/onboarding_data.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<OnboardingModel> _onboardingData =
      OnboardingData.getOnboardingData();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _floatingController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Restart slide animation for new page
    _slideController.reset();
    _slideController.forward();
  }

  void _nextPage() {
    if (_currentIndex < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  void _skipOnboarding() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF0A0E21),
                    const Color(0xFF1D1E33),
                    const Color(0xFF2A2D3A),
                    const Color(0xFF0A0E21),
                  ]
                : [
                    const Color(0xFFE8F0FE),
                    const Color(0xFFF8F9FB),
                    const Color(0xFFE3F2FD),
                    const Color(0xFFF1F8E9),
                  ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header with Skip button and Theme toggle
                _buildHeader(isDarkMode),

                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return _buildOnboardingContent(_onboardingData[index]);
                    },
                  ),
                ),

                // Bottom section with indicators and button
                _buildBottomSection(isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                // padding: const EdgeInsets.all(12),
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     colors: _onboardingData[_currentIndex].gradientColors,
                //   ),
                //   borderRadius: BorderRadius.circular(15),
                //   boxShadow: [
                //     BoxShadow(
                //       color: _onboardingData[_currentIndex].gradientColors.first
                //           .withAlpha(77),
                //       blurRadius: 15,
                //       offset: const Offset(0, 8),
                //     ),
                //   ],
                // ),
                // child: const Icon(
                //   Icons.delivery_dining_rounded,
                //   size: 24,
                //   color: Colors.white,
                // ),
              ),
              // const SizedBox(width: 12),
              // Text(
              //   'Kurir Atapange',
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: textColor,
              //   ),
              // ),
            ],
          ),

          // Skip button and theme toggle
          Row(
            children: [
              // IconButton(
              //   icon: Icon(
              //     isDarkMode ? Icons.light_mode : Icons.dark_mode,
              //     color: textColor,
              //   ),
              //   onPressed: () {
              //     themeNotifier.value = isDarkMode
              //         ? ThemeMode.light
              //         : ThemeMode.dark;
              //   },
              // ),
              TextButton(
                onPressed: _skipOnboarding,
                child: Text(
                  'Lewati',
                  style: TextStyle(
                    color: textColor.withAlpha(180),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingContent(OnboardingModel data) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Floating Icon Container
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: (isDarkMode ? Colors.white : Colors.black)
                            .withAlpha(13),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: GlassContainer(
                    width: 200,
                    height: 200,
                    borderRadius: BorderRadius.circular(40),
                    child: Stack(
                      children: [
                        // Background gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                data.gradientColors.first.withAlpha(51),
                                data.gradientColors.last.withAlpha(26),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        // Icon
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: data.gradientColors,
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: data.gradientColors.first.withAlpha(
                                    77,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Text(
                              data.icon,
                              style: const TextStyle(fontSize: 60),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Welcome badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        data.gradientColors.first.withAlpha(51),
                        data.gradientColors.first.withAlpha(26),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: data.gradientColors.first.withAlpha(77),
                    ),
                  ),
                  child: Text(
                    data.title,
                    style: TextStyle(
                      color: data.gradientColors.first,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Description
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(20),
                //     boxShadow: [
                //       BoxShadow(
                //         color: (isDarkMode ? Colors.white : Colors.black)
                //             .withAlpha(13),
                //         blurRadius: 20,
                //         offset: const Offset(0, 10),
                //       ),
                //     ],
                //   ),
                //   child: GlassContainer(
                //     width: double.infinity,
                //     padding: const EdgeInsets.all(25),
                //     borderRadius: BorderRadius.circular(20),
                //     child:
                Text(
                  data.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withAlpha(180),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection(bool isDarkMode) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Page Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentIndex == index ? 24 : 8,
                decoration: BoxDecoration(
                  gradient: _currentIndex == index
                      ? LinearGradient(
                          colors: _onboardingData[_currentIndex].gradientColors,
                        )
                      : null,
                  color: _currentIndex == index
                      ? null
                      : textColor.withAlpha(77),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Action Buttons
          Row(
            children: [
              // Previous Button (if not first page)
              if (_currentIndex > 0)
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: _onboardingData[_currentIndex]
                            .gradientColors
                            .first
                            .withAlpha(77),
                      ),

                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: _onboardingData[_currentIndex]
                              .gradientColors
                              .first
                              .withAlpha(77),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentIndex > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.black,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Kembali',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              if (_currentIndex > 0) const SizedBox(width: 15),

              // Next/Get Started Button
              Expanded(
                flex: _currentIndex > 0 ? 1 : 1,
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _onboardingData[_currentIndex].gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: _onboardingData[_currentIndex]
                            .gradientColors
                            .first
                            .withAlpha(77),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentIndex == _onboardingData.length - 1
                              ? 'Mulai'
                              : 'Selanjutnya',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentIndex == _onboardingData.length - 1
                              ? Icons.rocket_launch_rounded
                              : Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Additional Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: (isDarkMode ? Colors.white : Colors.black).withAlpha(
                    13,
                  ),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: GlassContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              borderRadius: BorderRadius.circular(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.security_rounded,
                    color: _onboardingData[_currentIndex].gradientColors.first,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Aman • Terpercaya • Terjangkau',
                    style: TextStyle(
                      color: textColor.withAlpha(180),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
