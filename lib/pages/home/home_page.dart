import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_kurir_app/util/performace_util.dart';
import 'package:my_kurir_app/util/session_manager.dart';
import '../../widgets/glass_container.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _controller;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;

  Future<bool> _onWillPop() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.logout_rounded,
              size: 40,
              color: Color(0xFFf5576c),
            ),
            const SizedBox(height: 16),
            const Text(
              'Keluar dari aplikasi?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Apakah Anda yakin ingin logout?',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFf5576c),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    if (result == true) {
      await SessionManager.clearSession();
      if (mounted) {
        Navigator.of(context).pop(); // keluar dari halaman home
      }
      return false; // jangan pop otomatis, sudah di-handle
    }
    return false; // batal, tetap di halaman
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Simulasi loading data
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final textColor =
    //     Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return PopScope(
      canPop: false, // agar pop dikontrol manual
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _onWillPop(); // panggil fungsi konfirmasi logout
      },
      child: Scaffold(
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
            child: _isLoading
                ? _buildLoadingScreen()
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Animated Header
                          _buildHeader(),
                          const SizedBox(height: 30),

                          // Floating Hero Banner
                          _buildHeroBanner(),
                          const SizedBox(height: 40),

                          // Quick Stats
                          _buildQuickStats(),
                          const SizedBox(height: 30),

                          // Service Cards with staggered animation
                          _buildSectionTitle('🚀 Layanan Kami'),
                          const SizedBox(height: 20),
                          _buildServiceCards(),
                          const SizedBox(height: 40),

                          // Features Grid
                          // _buildSectionTitle('✨ Keunggulan Kami'),
                          // const SizedBox(height: 20),
                          // _buildFeaturesGrid(),
                          // const SizedBox(height: 40),

                          // Info Cards with enhanced design
                          _buildSectionTitle('📋 Informasi Layanan'),
                          const SizedBox(height: 20),
                          _buildEnhancedInfoCards(),
                          const SizedBox(height: 30),

                          // Testimonial Section
                          // _buildTestimonialSection(),
                          // const SizedBox(height: 30),

                          // Call to Action
                          // _buildCallToAction(),
                          // const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [const Color(0xFF667eea), const Color(0xFF764ba2)]
                    : [const Color(0xFF4A80F0), const Color(0xFF6C63FF)],
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      (isDarkMode
                              ? const Color(0xFF667eea)
                              : const Color(0xFF4A80F0))
                          .withAlpha(77),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: const Icon(
              Icons.delivery_dining_rounded,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            'Memuat Kurir Atapange...',
            style: TextStyle(
              fontSize: 16,
              color:
                  Theme.of(
                    context,
                  ).textTheme.bodyLarge?.color?.withAlpha(180) ??
                  Colors.white.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [
                            const Color(0xFF00BCD4).withAlpha(51),
                            const Color(0xFF00BCD4).withAlpha(26),
                          ]
                        : [
                            const Color(0xFF4A80F0).withAlpha(51),
                            const Color(0xFF4A80F0).withAlpha(26),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDarkMode
                        ? const Color(0xFF00BCD4).withAlpha(77)
                        : const Color(0xFF4A80F0).withAlpha(77),
                  ),
                ),
                child: Text(
                  '👋 Selamat Datang',
                  style: TextStyle(
                    color: isDarkMode
                        ? const Color(0xFF00BCD4)
                        : const Color(0xFF4A80F0),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Kurir Atapange',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  shadows: isDarkMode
                      ? [
                          Shadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
              Text(
                'Solusi pengiriman terpercaya',
                style: TextStyle(fontSize: 16, color: textColor.withAlpha(180)),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.push('/profile'),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (isDarkMode ? Colors.white : Colors.black).withAlpha(
                    26,
                  ),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: GlassContainer(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(15),
              child: Icon(Icons.person_rounded, color: textColor, size: 28),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBanner() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? Colors.white : Colors.black).withAlpha(13),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: GlassContainer(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // Background decoration
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00BCD4).withAlpha(26),
                      const Color(0xFF00BCD4).withAlpha(13),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667eea).withAlpha(77),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.delivery_dining_rounded,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00BCD4).withAlpha(51),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF00BCD4).withAlpha(77),
                              ),
                            ),
                            child: const Text(
                              '🚀 Layanan Terpercaya',
                              style: TextStyle(
                                color: Color(0xFF00BCD4),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Text(
                  'Solusi Pengiriman\nuntuk Desa',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Kirim barang dengan mudah, cepat, dan terpercaya langsung ke rumah Anda. Melayani 24/7 dengan harga terjangkau.',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withAlpha(180),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    _buildQuickActionButton(
                      'Pesan Sekarang',
                      Icons.rocket_launch_rounded,
                      const LinearGradient(
                        colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                      ),
                      () => context.push('/order'),
                    ),
                    const SizedBox(width: 15),
                    _buildQuickActionButton(
                      'Lacak Pesanan',
                      Icons.track_changes_rounded,
                      LinearGradient(
                        colors: [
                          textColor.withAlpha(51),
                          textColor.withAlpha(26),
                        ],
                      ),
                      () => context.push('/tracking'),
                      isSecondary: true,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Gradient gradient,
    VoidCallback onTap, {
    bool isSecondary = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: isSecondary ? null : gradient,
          borderRadius: BorderRadius.circular(15),
          border: isSecondary
              ? Border.all(
                  color: isDarkMode
                      ? Colors.white.withAlpha(77)
                      : Colors.black.withAlpha(77),
                  width: 1.5,
                )
              : null,
          boxShadow: isSecondary
              ? null
              : [
                  BoxShadow(
                    color: gradient.colors.first.withAlpha(77),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSecondary ? textColor : Colors.white,
                size: 12,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSecondary ? textColor : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '150+',
            'Pesanan Selesai',
            Icons.check_circle_rounded,
            const Color(0xFF43e97b),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatCard(
            '4.9',
            'Rating\nKurir',
            Icons.star_rounded,
            const Color(0xFFffd700),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatCard(
            '24/7',
            '\nLayanan',
            Icons.access_time_rounded,
            const Color(0xFF4facfe),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? Colors.white : Colors.black).withAlpha(13),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(51),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: textColor.withAlpha(180)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildServiceCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildModernServiceCard(
                context,
                icon: Icons.add_shopping_cart_rounded,
                title: 'Pesan Kurir',
                subtitle: 'Antar barang dari toko',
                description:
                    'Pesan kurir untuk mengantarkan barang belanjaan Anda',
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                onTap: () => context.push('/order'),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildModernServiceCard(
                context,
                icon: Icons.track_changes_rounded,
                title: 'Lacak Pesanan',
                subtitle: 'Pantau real-time',
                description: 'Lacak posisi kurir dan status pengiriman',
                gradient: const LinearGradient(
                  colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                ),
                onTap: () => context.push('/tracking'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildModernServiceCard(
                context,
                icon: Icons.history_rounded,
                title: 'Riwayat',
                subtitle: 'Pesanan Lama',
                description: 'Lihat riwayat pesanan sebelumnya',
                gradient: const LinearGradient(
                  colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                ),
                onTap: () => context.push('/history'),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildModernServiceCard(
                context,
                icon: Icons.support_agent_rounded,
                title: 'Bantuan',
                subtitle: 'Customer Service',
                description: 'Hubungi tim support untuk bantuan',
                gradient: const LinearGradient(
                  colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                ),
                onTap: () => _showHelpDialog(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModernServiceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final useSimple = PerformanceUtils.shouldUseSimpleGlass();
    if (useSimple) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withAlpha(30),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withAlpha(30), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withAlpha(60),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const Spacer(),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),

                // Description
                SizedBox(
                  height: 40,
                  child: Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withAlpha(200),
                      height: 1.3,
                    ),
                  ),
                ),

                // Arrow indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: (isDarkMode ? Colors.white : Colors.black).withAlpha(13),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              children: [
                // Background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                // Glass effect overlay
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(26),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white.withAlpha(51)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(icon, color: Colors.white, size: 28),
                        ),
                        const Spacer(),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Text(
                        //   subtitle,
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //     color: Colors.white.withAlpha(204),
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                        SizedBox(
                          height: 40,
                          child: Text(
                            description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withAlpha(179),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  // Widget _buildFeaturesGrid() {
  //   final features = [
  //     {
  //       'icon': Icons.flash_on_rounded,
  //       'title': 'Cepat',
  //       'desc': '15-30 menit',
  //       'color': const Color(0xFFffd700),
  //     },
  //     {
  //       'icon': Icons.security_rounded,
  //       'title': 'Aman',
  //       'desc': 'Kurir terpercaya',
  //       'color': const Color(0xFF43e97b),
  //     },
  //     {
  //       'icon': Icons.payments_rounded,
  //       'title': 'Murah',
  //       'desc': 'Mulai Rp 3.000',
  //       'color': const Color(0xFF4facfe),
  //     },
  //     {
  //       'icon': Icons.support_agent_rounded,
  //       'title': '24/7',
  //       'desc': 'Siap melayani',
  //       'color': const Color(0xFFf093fb),
  //     },
  //   ];

  //   return GridView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       crossAxisSpacing: 15,
  //       mainAxisSpacing: 15,
  //       childAspectRatio: 1.2,
  //     ),
  //     itemCount: features.length,
  //     itemBuilder: (context, index) {
  //       final feature = features[index];
  //       return _buildFeatureCard(
  //         feature['icon'] as IconData,
  //         feature['title'] as String,
  //         feature['desc'] as String,
  //         feature['color'] as Color,
  //       );
  //     },
  //   );
  // }

  // Widget _buildFeatureCard(
  //   IconData icon,
  //   String title,
  //   String description,
  //   Color color,
  // ) {
  //   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  //   final textColor =
  //       Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: (isDarkMode ? Colors.white : Colors.black).withAlpha(13),
  //           blurRadius: 15,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: GlassContainer(
  //       padding: const EdgeInsets.all(20),
  //       borderRadius: BorderRadius.circular(20),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.all(15),
  //             decoration: BoxDecoration(
  //               color: color.withAlpha(51),
  //               borderRadius: BorderRadius.circular(15),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: color.withAlpha(26),
  //                   blurRadius: 10,
  //                   offset: const Offset(0, 5),
  //                 ),
  //               ],
  //             ),
  //             child: Icon(icon, color: color, size: 30),
  //           ),
  //           const SizedBox(height: 15),
  //           Text(
  //             title,
  //             style: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //               color: textColor,
  //             ),
  //           ),
  //           const SizedBox(height: 5),
  //           Text(
  //             description,
  //             style: TextStyle(fontSize: 14, color: textColor.withAlpha(180)),
  //             textAlign: TextAlign.center,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildEnhancedInfoCards() {
    return Column(
      children: [
        _buildEnhancedInfoCard(
          icon: Icons.access_time_rounded,
          title: 'Jam Operasional',
          content: 'Senin - Minggu\n08:00 - 20:00 WIB',
          color: const Color(0xFF4facfe),
          subtitle: 'Melayani setiap hari',
        ),
        const SizedBox(height: 15),
        _buildEnhancedInfoCard(
          icon: Icons.payments_rounded,
          title: 'Tarif Pengiriman',
          content:
              'Dalam desa: Rp 3.000\nAntar desa: Rp 5.000\nUrgent: +Rp 2.000',
          color: const Color(0xFF43e97b),
          subtitle: 'Harga terjangkau untuk semua',
        ),
        const SizedBox(height: 15),
        _buildEnhancedInfoCard(
          icon: Icons.support_agent_rounded,
          title: 'Kontak Darurat',
          content: 'WhatsApp: +62 812-3456-7890\nRespon cepat 24/7',
          color: const Color(0xFFfa709a),
          subtitle: 'Siap membantu kapan saja',
        ),
      ],
    );
  }

  Widget _buildEnhancedInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required String subtitle,
    required Color color,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? Colors.white : Colors.black).withAlpha(13),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: GlassContainer(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        borderRadius: BorderRadius.circular(25),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withAlpha(150)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha(77),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withAlpha(180),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: GlassContainer(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFffeaa7), Color(0xFFfdcb6e)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.help_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Bantuan & FAQ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHelpSection(
                          context,
                          '🚀 Cara Menggunakan Aplikasi:',
                          [
                            '1. Pilih "Pesan Kurir" di beranda',
                            '2. Isi form dengan lengkap dan benar',
                            '3. Tunggu konfirmasi dari kurir via WhatsApp',
                            '4. Lacak pesanan secara real-time',
                            '5. Bayar cash saat barang sampai tujuan',
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildHelpSection(context, '❓ Frequently Asked Questions:', [
                          'Q: Berapa lama waktu pengiriman?\nA: 15-30 menit untuk dalam desa',
                          'Q: Bagaimana cara pembayaran?\nA: Cash saat barang sampai di tujuan',
                          'Q: Bisa antar ke luar desa?\nA: Bisa, dengan tarif Rp 5.000',
                          'Q: Apakah ada jaminan keamanan?\nA: Ya, semua kurir sudah terverifikasi',
                        ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(
    BuildContext context,
    String title,
    List<String> items,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode
                    ? Colors.white.withAlpha(204)
                    : Colors.black87.withAlpha(204),
                height: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildTestimonialSection() {
  //   // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  //   // final textColor =
  //   //     Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildSectionTitle('💬 Kata Mereka'),
  //       const SizedBox(height: 20),
  //       SizedBox(
  //         height: 180,
  //         child: ListView(
  //           scrollDirection: Axis.horizontal,
  //           physics: const BouncingScrollPhysics(),
  //           children: [
  //             _buildTestimonialCard(
  //               'Budi Santoso',
  //               'Pelanggan Setia',
  //               'Pelayanan sangat cepat dan kurir ramah. Barang sampai dengan selamat!',
  //               '⭐⭐⭐⭐⭐',
  //               const Color(0xFF43e97b),
  //             ),
  //             const SizedBox(width: 15),
  //             _buildTestimonialCard(
  //               'Siti Aminah',
  //               'Ibu Rumah Tangga',
  //               'Sangat membantu untuk belanja harian. Harga terjangkau dan terpercaya.',
  //               '⭐⭐⭐⭐⭐',
  //               const Color(0xFF4facfe),
  //             ),
  //             const SizedBox(width: 15),
  //             _buildTestimonialCard(
  //               'Ahmad Fauzi',
  //               'Pedagang',
  //               'Kurir Atapange selalu jadi andalan untuk kirim barang ke pelanggan.',
  //               '⭐⭐⭐⭐⭐',
  //               const Color(0xFFf093fb),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildTestimonialCard(
  //   String name,
  //   String role,
  //   String testimonial,
  //   String rating,
  //   Color accentColor,
  // ) {
  //   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  //   final textColor =
  //       Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

  //   return Container(
  //     width: 280,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: (isDarkMode ? Colors.white : Colors.black).withAlpha(13),
  //           blurRadius: 15,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: GlassContainer(
  //       padding: const EdgeInsets.all(20),
  //       borderRadius: BorderRadius.circular(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 width: 50,
  //                 height: 50,
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     colors: [accentColor, accentColor.withAlpha(150)],
  //                   ),
  //                   borderRadius: BorderRadius.circular(15),
  //                 ),
  //                 child: const Icon(
  //                   Icons.person_rounded,
  //                   color: Colors.white,
  //                   size: 25,
  //                 ),
  //               ),
  //               const SizedBox(width: 15),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       name,
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                         color: textColor,
  //                       ),
  //                     ),
  //                     Text(
  //                       role,
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         color: accentColor,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 15),
  //           Text(
  //             testimonial,
  //             style: TextStyle(
  //               fontSize: 14,
  //               color: textColor.withAlpha(180),
  //               height: 1.4,
  //             ),
  //           ),
  //           const Spacer(),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(rating, style: const TextStyle(fontSize: 16)),
  //               Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 10,
  //                   vertical: 4,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: accentColor.withAlpha(51),
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Text(
  //                   'Verified',
  //                   style: TextStyle(
  //                     fontSize: 10,
  //                     color: accentColor,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildCallToAction() {
  //   // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  //   // final textColor =
  //   //     Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(30),
  //       boxShadow: [
  //         BoxShadow(
  //           color: const Color(0xFF667eea).withAlpha(77),
  //           blurRadius: 25,
  //           offset: const Offset(0, 15),
  //         ),
  //       ],
  //     ),
  //     child: Container(
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         gradient: const LinearGradient(
  //           colors: [Color(0xFF667eea), Color(0xFF764ba2)],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //         borderRadius: BorderRadius.circular(30),
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(30),
  //         child: BackdropFilter(
  //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //           child: Container(
  //             padding: const EdgeInsets.all(30),
  //             decoration: BoxDecoration(
  //               color: Colors.white.withAlpha(26),
  //               borderRadius: BorderRadius.circular(30),
  //               border: Border.all(color: Colors.white.withAlpha(51)),
  //             ),
  //             child: Column(
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.all(20),
  //                   decoration: BoxDecoration(
  //                     color: Colors.white.withAlpha(51),
  //                     borderRadius: BorderRadius.circular(20),
  //                   ),
  //                   child: const Icon(
  //                     Icons.rocket_launch_rounded,
  //                     size: 40,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 const Text(
  //                   'Siap Pesan Kurir?',
  //                   style: TextStyle(
  //                     fontSize: 24,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 const Text(
  //                   'Mulai pengalaman pengiriman yang mudah dan terpercaya bersama Kurir Atapange',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Colors.white,
  //                     height: 1.4,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 const SizedBox(height: 25),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: Container(
  //                         height: 55,
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(18),
  //                           boxShadow: [
  //                             BoxShadow(
  //                               color: Colors.black.withAlpha(26),
  //                               blurRadius: 15,
  //                               offset: const Offset(0, 8),
  //                             ),
  //                           ],
  //                         ),
  //                         child: ElevatedButton(
  //                           onPressed: () => context.push('/order'),
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.white,
  //                             foregroundColor: const Color(0xFF667eea),
  //                             shadowColor: Colors.transparent,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(18),
  //                             ),
  //                           ),
  //                           child: const Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Icon(Icons.add_shopping_cart_rounded, size: 20),
  //                               SizedBox(width: 10),
  //                               Text(
  //                                 'Pesan Sekarang',
  //                                 style: TextStyle(
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 15),
  //                     Container(
  //                       height: 55,
  //                       width: 55,
  //                       decoration: BoxDecoration(
  //                         color: Colors.white.withAlpha(51),
  //                         borderRadius: BorderRadius.circular(18),
  //                         border: Border.all(color: Colors.white.withAlpha(77)),
  //                       ),
  //                       child: IconButton(
  //                         onPressed: () => context.push('/profile'),
  //                         icon: const Icon(
  //                           Icons.help_outline_rounded,
  //                           color: Colors.white,
  //                           size: 24,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
