import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_kurir_app/pages/tracking/cubit/tracking_cubit.dart';
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
  final String url = "https://kurir-tracking.vercel.app/";
  bool isLoading = true;
  String? errorMessage;

  int _statusToIndex(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.pickingUp:
        return 2;
      case OrderStatus.onTheWay:
        return 3;
      case OrderStatus.delivered:
        return 4;
      default:
        return 0;
    }
  }

  final timelineSteps = [
    'Menunggu Konfirmasi',
    'Dikonfirmasi',
    'Kurir Mengambil Barang',
    'Dalam Perjalanan',
    'Terkirim',
  ];
  late OrderModel currentOrder;

  @override
  void initState() {
    super.initState();
    context.read<TrackingCubit>().fetchActiveOrder();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    return BlocBuilder<TrackingCubit, TrackingState>(
      builder: (context, state) {
        if (state is TrackingFailure) {
          return Scaffold(
            backgroundColor: isDarkMode
                ? const Color(0xFF0A0E21)
                : const Color(0xFFF8F9FB),
            body: SafeArea(
              child: Column(
                children: [
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
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: textColor,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            'Lacak Kurir Atapange',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 50),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: Colors.redAccent.withAlpha(180),
                            size: 60,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Gagal memuat pesanan aktif',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor.withAlpha(150),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Coba Lagi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF667eea),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 24,
                              ),
                            ),
                            onPressed: () {
                              context.read<TrackingCubit>().fetchActiveOrder();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is TrackingLoading || state is TrackingInitial) {
          return Scaffold(
            backgroundColor: isDarkMode
                ? const Color(0xFF0A0E21)
                : const Color(0xFFF8F9FB),
            body: SafeArea(
              child: Column(
                children: [
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
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: textColor,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            'Lacak Kurir Atapange',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 50),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00BCD4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is TrackingNoActiveOrder) {
          return Scaffold(
            backgroundColor: isDarkMode
                ? const Color(0xFF0A0E21)
                : const Color(0xFFF8F9FB),
            body: SafeArea(
              child: Column(
                children: [
                  // Custom App Bar (konsisten dengan halaman lain)
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
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: textColor,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            'Lacak Kurir Atapange',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ), // Placeholder biar rata tengah
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        margin: EdgeInsets.only(bottom: 48),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_rounded,
                              size: 90,
                              color: Colors.grey.withAlpha(75),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Tidak Ada Pesanan Aktif',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Kamu belum memiliki pesanan yang sedang berjalan.\nSilakan buat pesanan baru jika membutuhkan layanan kurir.',
                              style: TextStyle(
                                fontSize: 16,
                                color: textColor.withAlpha(160),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 64),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is TrackingLoaded) {
          currentOrder = state.order;
          final currentStep = _statusToIndex(currentOrder.status);
          final timelineTimes = [
            currentOrder.createdAt,
            currentOrder.confirmedAt,
            currentOrder.pickingUpAt,
            currentOrder.onTheWayAt,
            currentOrder.deliveredAt,
          ];

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
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: textColor,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              'Lacak Kurir Atapange',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _refreshWebView,
                            child: GlassContainer(
                              width: 50,
                              height: 50,
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.refresh_rounded,
                                color: textColor,
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
                                          currentOrder.status.color.withAlpha(
                                            179,
                                          ),
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
                                      color: textColor.withAlpha(150),
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
                                          url: WebUri(
                                            '$url/track/${currentOrder.id}',
                                          ),
                                        ),
                                        initialSettings: InAppWebViewSettings(
                                          useShouldOverrideUrlLoading: false,
                                          mediaPlaybackRequiresUserGesture:
                                              false,
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
                                                errorMessage =
                                                    error.description;
                                              });
                                            },
                                        onReceivedHttpError:
                                            (
                                              controller,
                                              request,
                                              errorResponse,
                                            ) {
                                              setState(() {
                                                isLoading = false;
                                                errorMessage =
                                                    'HTTP Error: ${errorResponse.statusCode}';
                                              });
                                            },
                                        onProgressChanged:
                                            (controller, progress) {
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
                                                action: PermissionResponseAction
                                                    .GRANT,
                                              );
                                            },
                                      ),
                                    if (isLoading && errorMessage == null)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? Colors.black.withAlpha(77)
                                              : Colors.black.withAlpha(20),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                                  Text(
                                    '👨‍🚚 Informasi Kurir',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
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
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
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
                                            Text(
                                              currentOrder.kurirName ?? '-',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              currentOrder.kurirPhone ?? '-',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: textColor.withAlpha(150),
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

                            // Timeline
                            GlassContainer(
                              width: double.infinity,
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '📍 Timeline Pengiriman',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 25),

                                  for (int i = 0; i < timelineSteps.length; i++)
                                    _buildTimelineItem(
                                      timelineSteps[i],
                                      timelineTimes[i] != null
                                          ? _formatDateTime(timelineTimes[i]!)
                                          : '-',
                                      i <= currentStep,
                                      isLast: i == timelineSteps.length - 1,
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.payment_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        'Info Pembayaran',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  _buildPaymentRow(
                                    '💰',
                                    'Ongkir',
                                    'Rp ${currentOrder.total}',
                                  ),
                                  _buildPaymentRow(
                                    '💳',
                                    'Metode',
                                    'Cash saat terima',
                                  ),
                                  // _buildPaymentRow(
                                  //   '✅',
                                  //   'Status',
                                  //   currentOrder.status == OrderStatus.delivered
                                  //       ? 'Sudah dibayar'
                                  //       : 'Belum dibayar',
                                  //   statusColor:
                                  //       currentOrder.status ==
                                  //           OrderStatus.delivered
                                  //       ? const Color(0xFF43e97b)
                                  //       : const Color(0xFFfdcb6e),
                                  // ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Tombol Detail Pesanan
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.receipt_long_rounded,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Detail Pesanan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF667eea),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                onPressed: () =>
                                    _showOrderDetails(currentOrder),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Tombol Batalkan Pesanan (hanya jika status pending)
                            // if (currentOrder.status == OrderStatus.pending)
                            //   SizedBox(
                            //     width: double.infinity,
                            //     child: ElevatedButton.icon(
                            //       icon: const Icon(
                            //         Icons.cancel_rounded,
                            //         color: Colors.white,
                            //       ),
                            //       label: const Text(
                            //         'Batalkan Pesanan',
                            //         style: TextStyle(
                            //           color: Colors.white,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //       style: ElevatedButton.styleFrom(
                            //         backgroundColor: const Color(0xFFf5576c),
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(15),
                            //         ),
                            //         padding: const EdgeInsets.symmetric(
                            //           vertical: 16,
                            //         ),
                            //       ),
                            //       onPressed: () async {
                            //         final confirm = await showDialog<bool>(
                            //           context: context,
                            //           builder: (context) => AlertDialog(
                            //             title: const Text(
                            //               'Konfirmasi Pembatalan',
                            //             ),
                            //             content: const Text(
                            //               'Yakin ingin membatalkan pesanan ini?',
                            //             ),
                            //             actions: [
                            //               TextButton(
                            //                 onPressed: () => Navigator.of(
                            //                   context,
                            //                 ).pop(false),
                            //                 child: const Text('Batal'),
                            //               ),
                            //               TextButton(
                            //                 onPressed: () =>
                            //                     Navigator.of(context).pop(true),
                            //                 child: const Text('Ya, Batalkan'),
                            //               ),
                            //             ],
                            //           ),
                            //         );
                            //         if (confirm == true) {
                            //           if (!context.mounted) return;
                            //           await context
                            //               .read<TrackingCubit>()
                            //               .cancelOrder(currentOrder.id);
                            //           if (!context.mounted) return;
                            //           ScaffoldMessenger.of(
                            //             context,
                            //           ).showSnackBar(
                            //             const SnackBar(
                            //               content: Text(
                            //                 'Pesanan berhasil dibatalkan.',
                            //               ),
                            //               backgroundColor: Color(0xFFf5576c),
                            //             ),
                            //           );
                            //           // Tidak perlu popUntil, UI akan otomatis refresh
                            //         }
                            //       },
                            //     ),
                            //   ),
                            if (currentOrder.status == OrderStatus.onTheWay)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Selesaikan Pesanan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF43e97b),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Konfirmasi Selesai'),
                                        content: const Text(
                                          'Yakin ingin menyelesaikan pesanan ini?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(
                                              context,
                                            ).pop(false),
                                            child: const Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text('Ya, Selesaikan'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await context
                                          .read<TrackingCubit>()
                                          .completeOrder(currentOrder.id);
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Pesanan telah diselesaikan.',
                                          ),
                                          backgroundColor: Color(0xFF43e97b),
                                        ),
                                      );
                                    }
                                  },
                                ),
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
        return const SizedBox();
      },
    );
  }

  void _showOrderDetails(OrderModel order) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

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
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Detail Pesanan',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildOrderDetailRow('ID Pesanan', order.id),
                        _buildOrderDetailRow(
                          'Tanggal Pesan',
                          _formatDateTime(order.createdAt),
                        ),

                        _buildOrderDetailRow(
                          'Alamat Jemput',
                          order.alamatJemput,
                        ),
                        _buildOrderDetailRow('Alamat Antar', order.alamatAntar),
                        _buildOrderDetailRow('Jenis Barang', order.jenisBarang),
                        if (order.catatan != null && order.catatan!.isNotEmpty)
                          _buildOrderDetailRow('Catatan', order.catatan!),
                        _buildOrderDetailRow(
                          'Urgent',
                          order.isUrgent ? 'Ya' : 'Tidak',
                        ),
                        _buildOrderDetailRow(
                          'Total Ongkir',
                          'Rp ${order.total}',
                        ),
                        _buildOrderDetailRow(
                          'Status',
                          order.status.displayName,
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
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

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
                color: textColor.withAlpha(150),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildErrorState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.black.withAlpha(77)
            : Colors.black.withAlpha(20),
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
            Text(
              'Fitur tracking belum tersedia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            // Text(
            //   errorMessage ?? 'Terjadi kesalahan',
            //   style: TextStyle(fontSize: 14, color: textColor.withAlpha(150)),
            //   textAlign: TextAlign.center,
            // ),
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

  Widget _buildTimelineItem(
    String title,
    String time,
    bool isCompleted, {
    bool isLast = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

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
                    : (isDarkMode
                          ? Colors.white.withAlpha(77)
                          : Colors.black.withAlpha(77)),
                border: Border.all(
                  color: isCompleted
                      ? const Color(0xFF43e97b)
                      : (isDarkMode
                            ? Colors.white.withAlpha(77)
                            : Colors.black.withAlpha(77)),
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
                    : (isDarkMode
                          ? Colors.white.withAlpha(51)
                          : Colors.black.withAlpha(51)),
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
                    color: isCompleted ? textColor : textColor.withAlpha(150),
                    fontWeight: isCompleted
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withAlpha(150),
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
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: textColor.withAlpha(140)),
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
    context.read<TrackingCubit>().fetchActiveOrder();
  }

  void _callKurir() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Membuka aplikasi telepon...'),
        backgroundColor: Color(0xFF4facfe),
      ),
    );
  }

  void _chatKurir() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Membuka WhatsApp...'),
        backgroundColor: Color(0xFF43e97b),
      ),
    );
  }
}
