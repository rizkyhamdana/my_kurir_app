import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import '../../models/order_model.dart';
import '../../widgets/glass_container.dart';
import 'dart:ui';

class TrackingPage extends StatefulWidget {
  final OrderModel? orderData;

  const TrackingPage({super.key, this.orderData});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  InAppWebViewController? webViewController;
  final String url = "http://localhost:3000";
  bool isLoading = true;
  String? errorMessage;

  late OrderModel _dummyOrder;

  @override
  void initState() {
    super.initState();
    _dummyOrder = OrderModel(
      id: 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
      nama: 'Budi Santoso',
      phone: '+62 812-3456-7890',
      alamatJemput: 'Warung Bu Siti, Jl. Raya Desa No. 15, RT 01/RW 02',
      alamatAntar:
          'Rumah Pak Budi, Jl. Melati No. 8, RT 03/RW 01, Dusun Krajan',
      jenisBarang: 'Makanan/Minuman',
      catatan: 'Sudah dibayar via transfer, tinggal ambil saja',
      isUrgent: true,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      status: OrderStatus.onTheWay,
    );
  }

  OrderModel get currentOrder => widget.orderData ?? _dummyOrder;

  @override
  Widget build(BuildContext context) {
    if (widget.orderData == null) {
      return _buildDemoScreen();
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E21), Color(0xFF1D1E33), Color(0xFF0A0E21)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: GlassContainer(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Text(
                        'Lacak Kurir Atapange',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _refreshWebView,
                      child: GlassContainer(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Demo Badge
                      if (currentOrder.id.startsWith('ORDER-'))
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFffeaa7), Color(0xFFfdcb6e)],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.science_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                '🧪 Mode Demo - Data Contoh',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Status Header
                      GlassContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    currentOrder.status.color,
                                    currentOrder.status.color.withAlpha(179),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.delivery_dining_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              currentOrder.status.displayName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: currentOrder.status.color,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pantau posisi kurir desa Anda secara real-time',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withAlpha(179),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // WebView Section
                      GlassContainer(
                        width: double.infinity,
                        height: 320,
                        padding: const EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              if (errorMessage != null)
                                _buildErrorState()
                              else
                                InAppWebView(
                                  initialUrlRequest: URLRequest(
                                    url: WebUri(url),
                                  ),
                                  initialSettings: InAppWebViewSettings(
                                    useShouldOverrideUrlLoading: false,
                                    mediaPlaybackRequiresUserGesture: false,
                                    javaScriptEnabled: true,
                                    domStorageEnabled: true,
                                    databaseEnabled: true,
                                    clearCache: false,
                                    cacheEnabled: true,
                                    mixedContentMode: MixedContentMode
                                        .MIXED_CONTENT_ALWAYS_ALLOW,
                                  ),
                                  onWebViewCreated: (controller) {
                                    webViewController = controller;
                                  },
                                  onLoadStart: (controller, url) {
                                    setState(() {
                                      isLoading = true;
                                      errorMessage = null;
                                    });
                                  },
                                  onLoadStop: (controller, url) async {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  onReceivedError:
                                      (controller, request, error) {
                                        setState(() {
                                          isLoading = false;
                                          errorMessage = error.description;
                                        });
                                      },
                                  onReceivedHttpError:
                                      (controller, request, errorResponse) {
                                        setState(() {
                                          isLoading = false;
                                          errorMessage =
                                              'HTTP Error: ${errorResponse.statusCode}';
                                        });
                                      },
                                  onProgressChanged: (controller, progress) {
                                    if (progress == 100) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                                  onPermissionRequest:
                                      (controller, request) async {
                                        return PermissionResponse(
                                          resources: request.resources,
                                          action:
                                              PermissionResponseAction.GRANT,
                                        );
                                      },
                                ),
                              if (isLoading && errorMessage == null)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(77),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Color(0xFF00BCD4),
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          'Memuat peta...',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
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
                      const SizedBox(height: 25),

                      // Kurir Info Card
                      GlassContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '👨‍🚚 Informasi Kurir',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF667eea),
                                        Color(0xFF764ba2),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Ahmad Kurniawan',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '+62 812-9876-5432',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white.withAlpha(179),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF43e97b,
                                          ).withAlpha(51),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: const Color(
                                              0xFF43e97b,
                                            ).withAlpha(77),
                                          ),
                                        ),
                                        child: const Text(
                                          '⭐ Rating 4.9',
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
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActionButton(
                                    icon: Icons.phone_rounded,
                                    label: 'Telepon',
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4facfe),
                                        Color(0xFF00f2fe),
                                      ],
                                    ),
                                    onTap: _callKurir,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildActionButton(
                                    icon: Icons.chat_rounded,
                                    label: 'WhatsApp',
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF43e97b),
                                        Color(0xFF38f9d7),
                                      ],
                                    ),
                                    onTap: _chatKurir,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Order Details
                      GlassContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '📦 Detail Pesanan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildDetailRow('👤', 'Pemesan', currentOrder.nama),
                            _buildDetailRow(
                              '🏪',
                              'Jemput dari',
                              currentOrder.alamatJemput,
                            ),
                            _buildDetailRow(
                              '🏠',
                              'Antar ke',
                              currentOrder.alamatAntar,
                            ),
                            _buildDetailRow(
                              '📦',
                              'Jenis Barang',
                              currentOrder.jenisBarang,
                            ),
                            if (currentOrder.catatan != null &&
                                currentOrder.catatan!.isNotEmpty)
                              _buildDetailRow(
                                '📝',
                                'Catatan',
                                currentOrder.catatan!,
                              ),
                            _buildDetailRow('⏰', 'Estimasi', '15-30 menit'),
                            _buildDetailRow(
                              '🚚',
                              'Status',
                              currentOrder.status.displayName,
                              valueColor: currentOrder.status.color,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Timeline
                      GlassContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '📍 Timeline Pengiriman',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 25),
                            _buildTimelineItem(
                              'Pesanan diterima',
                              '14:30',
                              true,
                            ),
                            _buildTimelineItem(
                              'Kurir menuju toko',
                              '14:35',
                              true,
                            ),
                            _buildTimelineItem(
                              'Mengambil barang',
                              '14:45',
                              true,
                            ),
                            _buildTimelineItem(
                              'Dalam perjalanan ke alamat',
                              '15:00',
                              currentOrder.status == OrderStatus.onTheWay,
                            ),
                            _buildTimelineItem(
                              'Barang sampai tujuan',
                              '-',
                              currentOrder.status == OrderStatus.delivered,
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Payment Info
                      GlassContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFffeaa7),
                                        Color(0xFFfdcb6e),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.payment_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                const Text(
                                  'Info Pembayaran',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildPaymentRow(
                              '💰',
                              'Ongkir',
                              'Rp ${currentOrder.totalCost}',
                            ),
                            _buildPaymentRow(
                              '💳',
                              'Metode',
                              'Cash saat terima',
                            ),
                            _buildPaymentRow(
                              '✅',
                              'Status',
                              currentOrder.status == OrderStatus.delivered
                                  ? 'Sudah dibayar'
                                  : 'Belum dibayar',
                              statusColor:
                                  currentOrder.status == OrderStatus.delivered
                                  ? const Color(0xFF43e97b)
                                  : const Color(0xFFfdcb6e),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.add_shopping_cart_rounded,
                              label: 'Pesan Lagi',
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                              onTap: () => context.pushReplacement('/order'),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.receipt_rounded,
                              label: 'Detail Order',
                              gradient: const LinearGradient(
                                colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                              ),
                              onTap: _showOrderDetails,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
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

  Widget _buildDemoScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E21), Color(0xFF1D1E33), Color(0xFF0A0E21)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // App Bar
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: GlassContainer(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Text(
                        'Lacak Pesanan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                // Demo Content
                Expanded(
                  child: Center(
                    child: GlassContainer(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(
                              Icons.delivery_dining_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            '🚀 Demo Mode',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Menampilkan contoh tracking pesanan dengan data dummy untuk demo aplikasi',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withAlpha(179),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                context.pushReplacement(
                                  '/tracking',
                                  extra: _dummyOrder,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.visibility_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Lihat Demo Tracking',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFF667eea),
                                width: 2,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.pushReplacement('/order'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_rounded,
                                    color: Color(0xFF667eea),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Pesan Kurir Baru',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF667eea),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(77),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFf5576c).withAlpha(51),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: Color(0xFFf5576c),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Gagal memuat peta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage ?? 'Terjadi kesalahan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withAlpha(179),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ElevatedButton(
                onPressed: _refreshWebView,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
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
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String emoji,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha(153),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String time,
    bool isCompleted, {
    bool isLast = false,
  }) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? const Color(0xFF43e97b)
                    : Colors.white.withAlpha(77),
                border: Border.all(
                  color: isCompleted
                      ? const Color(0xFF43e97b)
                      : Colors.white.withAlpha(77),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 10)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: isCompleted
                    ? const Color(0xFF43e97b)
                    : Colors.white.withAlpha(51),
              ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: isCompleted
                        ? Colors.white
                        : Colors.white.withAlpha(153),
                    fontWeight: isCompleted
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha(130),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(
    String emoji,
    String label,
    String value, {
    Color? statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withAlpha(204),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: statusColor ?? const Color(0xFF00BCD4),
            ),
          ),
        ],
      ),
    );
  }

  void _refreshWebView() {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    webViewController?.reload();
  }

  void _callKurir() {
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
                      colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.phone_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hubungi Kurir',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Ahmad Kurniawan\n+62 812-9876-5432',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.phone_rounded,
                        label: 'Telepon',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Membuka aplikasi telepon...'),
                              backgroundColor: Color(0xFF4facfe),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.sms_rounded,
                        label: 'SMS',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mengirim SMS...'),
                              backgroundColor: Color(0xFF43e97b),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _chatKurir() {
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
                      colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.chat_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Chat WhatsApp',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Akan membuka chat WhatsApp dengan kurir:',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                GlassContainer(
                  padding: const EdgeInsets.all(20),
                  alpha: 51,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ahmad Kurniawan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        '+62 812-9876-5432',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Pesan otomatis: "Halo Pak Ahmad, saya ${currentOrder.nama}. Bagaimana status pengiriman pesanan saya?"',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withAlpha(179),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white.withAlpha(77)),
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
                            'Batal',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.open_in_new_rounded,
                        label: 'Buka WA',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Membuka WhatsApp...'),
                              backgroundColor: Color(0xFF43e97b),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOrderDetails() {
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
                      colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.receipt_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Detail Pesanan',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildOrderDetailRow('ID Pesanan', currentOrder.id),
                        _buildOrderDetailRow(
                          'Tanggal Pesan',
                          _formatDateTime(currentOrder.createdAt),
                        ),
                        _buildOrderDetailRow('Nama Pemesan', currentOrder.nama),
                        _buildOrderDetailRow('No. HP', currentOrder.phone),
                        _buildOrderDetailRow(
                          'Alamat Jemput',
                          currentOrder.alamatJemput,
                        ),
                        _buildOrderDetailRow(
                          'Alamat Antar',
                          currentOrder.alamatAntar,
                        ),
                        _buildOrderDetailRow(
                          'Jenis Barang',
                          currentOrder.jenisBarang,
                        ),
                        if (currentOrder.catatan != null &&
                            currentOrder.catatan!.isNotEmpty)
                          _buildOrderDetailRow(
                            'Catatan',
                            currentOrder.catatan!,
                          ),
                        _buildOrderDetailRow(
                          'Urgent',
                          currentOrder.isUrgent ? 'Ya' : 'Tidak',
                        ),
                        _buildOrderDetailRow(
                          'Total Ongkir',
                          'Rp ${currentOrder.totalCost}',
                        ),
                        _buildOrderDetailRow(
                          'Status',
                          currentOrder.status.displayName,
                        ),
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

  Widget _buildOrderDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white.withAlpha(204),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
