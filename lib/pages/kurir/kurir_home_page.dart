import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_kurir_app/util/session_manager.dart';
import '../../widgets/glass_container.dart';

class KurirHomePage extends StatefulWidget {
  const KurirHomePage({super.key});

  @override
  State<KurirHomePage> createState() => _KurirHomePageState();
}

class _KurirHomePageState extends State<KurirHomePage>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _isOnline = true; // Status kurir: true = online, false = offline

  late AnimationController _controller;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;

  // ... existing initState and dispose methods ...

  // Method untuk toggle status
  void _toggleStatus() {
    setState(() {
      _isOnline = !_isOnline;
    }); // Show snackbar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isOnline ? Icons.check_circle : Icons.cancel,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              _isOnline
                  ? 'Status: Online - Siap menerima pesanan'
                  : 'Status: Offline - Tidak menerima pesanan',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: _isOnline
            ? const Color(0xFF43e97b)
            : const Color(0xFFf5576c),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

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
              'Keluar dari akun kurir?',
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
                          _buildHeader(context),

                          const SizedBox(height: 30),
                          _buildStatusBanner(),
                          const SizedBox(height: 20),

                          // Floating Hero Banner
                          _buildHeroBanner(context),

                          const SizedBox(height: 40),

                          // Quick Stats
                          _buildQuickStats(),
                          const SizedBox(height: 30),

                          // Info Cards
                          _buildSectionTitle('📋 Info Kurir'),
                          const SizedBox(height: 20),
                          _buildEnhancedInfoCards(),
                          const SizedBox(height: 30),
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
                    ? [const Color(0xFF43e97b), const Color(0xFF38f9d7)]
                    : [const Color(0xFF667eea), const Color(0xFF764ba2)],
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      (isDarkMode
                              ? const Color(0xFF43e97b)
                              : const Color(0xFF667eea))
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
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF43e97b)),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            'Memuat Dashboard Kurir...',
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

  Widget _buildHeader(BuildContext context) {
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
                            const Color(0xFF43e97b).withAlpha(51),
                            const Color(0xFF43e97b).withAlpha(26),
                          ]
                        : [
                            const Color(0xFF667eea).withAlpha(51),
                            const Color(0xFF667eea).withAlpha(26),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDarkMode
                        ? const Color(0xFF43e97b).withAlpha(77)
                        : const Color(0xFF667eea).withAlpha(77),
                  ),
                ),
                child: Text(
                  '👋 Selamat Bertugas',
                  style: TextStyle(
                    color: isDarkMode
                        ? const Color(0xFF43e97b)
                        : const Color(0xFF667eea),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Dashboard Kurir',
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
                'Pantau & kelola pesanan Anda',
                style: TextStyle(fontSize: 16, color: textColor.withAlpha(180)),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigasi ke profil kurir
            context.push('/kurir-profile');
          },
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

  Widget _buildHeroBanner(BuildContext context) {
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
        padding: const EdgeInsets.all(35),
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
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
                      const Color(0xFF43e97b).withAlpha(26),
                      const Color(0xFF43e97b).withAlpha(13),
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
                          colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF43e97b).withAlpha(77),
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
                              color: const Color(0xFF43e97b).withAlpha(51),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF43e97b).withAlpha(77),
                              ),
                            ),
                            child: const Text(
                              '🚚 Siap Antar Pesanan',
                              style: TextStyle(
                                color: Color(0xFF43e97b),
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
                  'Ambil & Antar Barang\nDengan Mudah',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Kelola pesanan aktif, cek riwayat, dan tingkatkan layanan Anda sebagai kurir Atapange.',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withAlpha(180),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        'Pesanan Aktif',
                        Icons.list_alt_rounded,
                        const LinearGradient(
                          colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                        ),
                        () => context.push('/kurir-tracking'),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildQuickActionButton(
                        'Riwayat',
                        Icons.history_rounded,
                        LinearGradient(
                          colors: [
                            textColor.withAlpha(51),
                            textColor.withAlpha(26),
                          ],
                        ),
                        () => context.push('/kurir-history'),
                        isSecondary: true,
                      ),
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

  // Status Banner Widget
  Widget _buildStatusBanner() {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  (_isOnline
                          ? const Color(0xFF43e97b)
                          : const Color(0xFFf5576c))
                      .withAlpha(51),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              _isOnline ? Icons.check_circle : Icons.cancel,
              color: _isOnline
                  ? const Color(0xFF43e97b)
                  : const Color(0xFFf5576c),
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isOnline ? 'Status: Online' : 'Status: Offline',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isOnline
                      ? 'Siap menerima pesanan baru'
                      : 'Tidak menerima pesanan',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _toggleStatus,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isOnline
                      ? [const Color(0xFFf5576c), const Color(0xFFf093fb)]
                      : [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _isOnline ? 'Set Offline' : 'Set Online',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
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

    return Container(
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
            Icon(icon, color: isSecondary ? textColor : Colors.white, size: 12),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSecondary ? textColor : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final textColor =
    //     Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '12',
            'Pesanan Aktif',
            Icons.local_shipping_rounded,
            const Color(0xFF43e97b),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatCard(
            '150+',
            'Pesanan Selesai',
            Icons.check_circle_rounded,
            const Color(0xFFffd700),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatCard(
            '4.9',
            'Rating\nKurir',
            Icons.star_rounded,
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

  Widget _buildEnhancedInfoCards() {
    return Column(
      children: [
        _buildEnhancedInfoCard(
          icon: Icons.access_time_rounded,
          title: 'Jam Tugas',
          content: 'Senin - Minggu\n08:00 - 20:00 WIB',
          color: const Color(0xFF4facfe),
          subtitle: 'Pastikan selalu siap antar',
        ),
        const SizedBox(height: 15),
        _buildEnhancedInfoCard(
          icon: Icons.support_agent_rounded,
          title: 'Kontak Admin',
          content: 'WhatsApp: +62 812-3456-7890\nRespon cepat 24/7',
          color: const Color(0xFF43e97b),
          subtitle: 'Bantuan untuk kurir',
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
}
