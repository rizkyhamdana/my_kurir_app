import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/glass_container.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Simulasi loading data
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    final textColorFaded = textColor.withOpacity(0.7);

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
                    const Color(0xFF0A0E21),
                  ]
                : [
                    const Color(0xFFE8F0FE),
                    const Color(0xFFF8F9FB),
                    const Color(0xFFE8F0FE),
                  ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? Container()
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header dengan Profile
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selamat Datang di Aplikasi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: textColorFaded,
                                  ),
                                ),
                                Text(
                                  'Kurir Atapange',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineLarge,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => context.push('/profile'),
                              child: GlassContainer(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.person,
                                  color: textColor,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Hero Banner
                        GlassContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(30),
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
                                    color: const Color(
                                      0xFF00BCD4,
                                    ).withAlpha(77),
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
                              const SizedBox(height: 20),
                              Text(
                                'Solusi Pengiriman\nuntuk Desa',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineLarge,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Kirim barang dengan mudah, cepat, dan terpercaya langsung ke rumah Anda',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColorFaded,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Quick Actions
                        Text(
                          'Layanan Kami',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: _buildModernServiceCard(
                                icon: Icons.add_shopping_cart_rounded,
                                title: 'Pesan Kurir',
                                subtitle: 'Antar barang dari toko',
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF667eea),
                                    Color(0xFF764ba2),
                                  ],
                                ),
                                onTap: () => context.push('/order'),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildModernServiceCard(
                                icon: Icons.track_changes_rounded,
                                title: 'Lacak Pesanan',
                                subtitle: 'Pantau real-time',
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFf093fb),
                                    Color(0xFFf5576c),
                                  ],
                                ),
                                onTap: () => context.push('/tracking'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Info Cards
                        Text(
                          'Informasi Layanan',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 20),

                        _buildInfoCard(
                          icon: Icons.access_time_rounded,
                          title: 'Jam Operasional',
                          content: 'Senin - Minggu\n08:00 - 20:00 WIB',
                          color: const Color(0xFF4facfe),
                        ),
                        const SizedBox(height: 15),

                        _buildInfoCard(
                          icon: Icons.payments_rounded,
                          title: 'Tarif Pengiriman',
                          content:
                              'Dalam desa: Rp 3.000\nAntar desa: Rp 5.000\nUrgent: +Rp 2.000',
                          color: const Color(0xFF43e97b),
                        ),
                        const SizedBox(height: 15),

                        _buildInfoCard(
                          icon: Icons.support_agent_rounded,
                          title: 'Kontak Darurat',
                          content:
                              'WhatsApp: +62 812-3456-7890\nRespon cepat 24/7',
                          color: const Color(0xFFfa709a),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildModernServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withAlpha(77),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
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
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withAlpha(204),
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    final textColorFaded = textColor.withOpacity(0.7);

    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(51),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color.withAlpha(77)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColorFaded,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
