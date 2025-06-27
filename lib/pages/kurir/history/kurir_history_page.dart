import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/glass_container.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/order_model.dart';
import 'cubit/kurir_history_cubit.dart';

class KurirHistoryPage extends StatefulWidget {
  const KurirHistoryPage({super.key});

  @override
  State<KurirHistoryPage> createState() => _KurirHistoryPageState();
}

class _KurirHistoryPageState extends State<KurirHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<KurirHistoryCubit>().fetchHistory();
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
                          color: isDarkMode ? Colors.white : Colors.black87,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        'Riwayat Pesanan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Statistik summary (opsional, bisa diambil dari state jika ingin dinamis)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.analytics_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Pesanan Selesai',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode
                                    ? Colors.white.withAlpha(179)
                                    : Colors.black87.withAlpha(179),
                              ),
                            ),
                            const SizedBox(height: 4),
                            BlocBuilder<KurirHistoryCubit, KurirHistoryState>(
                              builder: (context, state) {
                                if (state is KurirHistoryLoaded) {
                                  final selesai = state.orders
                                      .where(
                                        (o) =>
                                            o.status == OrderStatus.delivered,
                                      )
                                      .length;
                                  return Text(
                                    '$selesai Pesanan',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  );
                                }
                                return const Text('-');
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF43e97b).withAlpha(51),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            BlocBuilder<KurirHistoryCubit, KurirHistoryState>(
                              builder: (context, state) {
                                if (state is KurirHistoryLoaded) {
                                  final hariIni = state.orders
                                      .where(
                                        (o) =>
                                            o.status == OrderStatus.delivered &&
                                            o.deliveredAt != null &&
                                            DateTime.now()
                                                    .difference(o.deliveredAt!)
                                                    .inDays ==
                                                0,
                                      )
                                      .length;
                                  return Text(
                                    '+$hariIni Hari ini',
                                    style: const TextStyle(
                                      color: Color(0xFF43e97b),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // History List
              Expanded(
                child: BlocBuilder<KurirHistoryCubit, KurirHistoryState>(
                  builder: (context, state) {
                    if (state is KurirHistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is KurirHistoryFailure) {
                      return Center(child: Text(state.message));
                    }
                    if (state is KurirHistoryLoaded) {
                      if (state.orders.isEmpty) {
                        return const Center(
                          child: Text('Belum ada riwayat pesanan.'),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.orders.length,
                        itemBuilder: (context, index) {
                          final order = state.orders[index];
                          return GlassContainer(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors:
                                              order.status ==
                                                  OrderStatus.delivered
                                              ? [
                                                  const Color(0xFF43e97b),
                                                  const Color(0xFF38f9d7),
                                                ]
                                              : [
                                                  const Color(0xFFf093fb),
                                                  const Color(0xFFf5576c),
                                                ],
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Icon(
                                        order.status == OrderStatus.delivered
                                            ? Icons.check_circle_rounded
                                            : Icons.cancel_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            order.status ==
                                                    OrderStatus.delivered
                                                ? 'Pesanan Selesai'
                                                : 'Pesanan Dibatalkan',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            order.id,
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white.withAlpha(179)
                                                  : Colors.black87.withAlpha(
                                                      179,
                                                    ),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: order.status.color.withAlpha(51),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        order.status.displayName,
                                        style: TextStyle(
                                          color: order.status.color,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.white.withAlpha(13)
                                        : Colors.black.withAlpha(5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      _buildDetailRow(
                                        context,
                                        Icons.location_on_rounded,
                                        'Alamat Antar',
                                        order.alamatAntar,
                                      ),
                                      const SizedBox(height: 10),
                                      _buildDetailRow(
                                        context,
                                        Icons.schedule_rounded,
                                        'Waktu Selesai',
                                        order.deliveredAt != null
                                            ? _formatDateTime(
                                                order.deliveredAt!,
                                              )
                                            : (order.cancelledAt != null
                                                  ? _formatDateTime(
                                                      order.cancelledAt!,
                                                    )
                                                  : '-'),
                                      ),
                                      const SizedBox(height: 10),
                                      _buildDetailRow(
                                        context,
                                        Icons.account_balance_wallet_rounded,
                                        'Pendapatan',
                                        'Rp ${order.total ?? 0}',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? Colors.white.withAlpha(26)
                                              : Colors.black.withAlpha(10),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: () =>
                                              _showOrderDetails(context, order),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.visibility_rounded,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black87,
                                            size: 18,
                                          ),
                                          label: Text(
                                            'Detail',
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF4facfe),
                                              Color(0xFF00f2fe),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: () => _showContactCustomer(
                                            context,
                                            order,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          icon: const Icon(
                                            Icons.phone_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          label: const Text(
                                            'Hubungi',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDarkMode
              ? Colors.white.withAlpha(179)
              : Colors.black87.withAlpha(179),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode
                ? Colors.white.withAlpha(179)
                : Colors.black87.withAlpha(179),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showOrderDetails(BuildContext context, OrderModel order) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: GlassContainer(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: order.status == OrderStatus.delivered
                          ? [const Color(0xFF43e97b), const Color(0xFF38f9d7)]
                          : [const Color(0xFFf093fb), const Color(0xFFf5576c)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    order.status == OrderStatus.delivered
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Detail Pesanan',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItem(context, 'ID Pesanan', order.id),
                        _buildDetailItem(context, 'Pelanggan', order.nama),
                        _buildDetailItem(context, 'No. Telepon', order.phone),
                        _buildDetailItem(
                          context,
                          'Alamat Jemput',
                          order.alamatJemput,
                        ),
                        _buildDetailItem(
                          context,
                          'Alamat Antar',
                          order.alamatAntar,
                        ),
                        _buildDetailItem(
                          context,
                          'Jenis Barang',
                          order.jenisBarang,
                        ),
                        _buildDetailItem(
                          context,
                          'Catatan',
                          order.catatan ?? '-',
                        ),
                        _buildDetailItem(
                          context,
                          'Waktu Selesai',
                          order.deliveredAt != null
                              ? _formatDateTime(order.deliveredAt!)
                              : (order.cancelledAt != null
                                    ? _formatDateTime(order.cancelledAt!)
                                    : '-'),
                        ),
                        _buildDetailItem(
                          context,
                          'Pendapatan',
                          'Rp ${order.total ?? 0}',
                        ),
                        _buildDetailItem(
                          context,
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

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode
                    ? Colors.white.withAlpha(179)
                    : Colors.black87.withAlpha(179),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactCustomer(BuildContext context, OrderModel order) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: GlassContainer(
            padding: const EdgeInsets.all(25),
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
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Hubungi Pelanggan',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  order.nama,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  order.phone,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode
                        ? Colors.white.withAlpha(179)
                        : Colors.black87.withAlpha(179),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _whatsappCustomer(order.phone);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          icon: const Icon(
                            Icons.message_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: const Text(
                            'WhatsApp',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _callCustomer(order.phone);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          icon: const Icon(
                            Icons.phone_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: const Text(
                            'Telepon',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withAlpha(26)
                        : Colors.black.withAlpha(10),
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
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
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

  void _whatsappCustomer(String phone) async {
    final wa = phone.replaceAll(RegExp(r'^0'), '62');
    final uri = Uri.parse('https://wa.me/$wa');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _callCustomer(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
