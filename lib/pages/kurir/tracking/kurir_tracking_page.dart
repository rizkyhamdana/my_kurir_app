import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widgets/glass_container.dart';
import 'cubit/kurir_tracking_cubit.dart';
import '../../../models/order_model.dart';

class KurirTrackingPage extends StatefulWidget {
  const KurirTrackingPage({super.key});

  @override
  State<KurirTrackingPage> createState() => _KurirTrackingPageState();
}

class _KurirTrackingPageState extends State<KurirTrackingPage> {
  @override
  void initState() {
    super.initState();
    context.read<KurirTrackingCubit>().fetchActiveOrders();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
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
                      'Tracking Pesanan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    onPressed: () =>
                        context.read<KurirTrackingCubit>().fetchActiveOrders(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<KurirTrackingCubit, KurirTrackingState>(
                builder: (context, state) {
                  if (state is KurirTrackingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is KurirTrackingFailure) {
                    return Center(child: Text(state.message));
                  }
                  if (state is KurirTrackingLoaded) {
                    if (state.orders.isEmpty) {
                      return Center(child: Text('Tidak ada pesanan aktif.'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        final order = state.orders[index];
                        return _buildOrderCard(context, order, isDarkMode);
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
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    OrderModel order,
    bool isDarkMode,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: order.status.color,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  order.id,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
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
          const SizedBox(height: 10),
          // Detail
          _buildDetailRow(Icons.person_rounded, 'Pelanggan', order.nama),
          _buildDetailRow(
            Icons.location_on_rounded,
            'Alamat Antar',
            order.alamatAntar,
          ),
          _buildDetailRow(
            Icons.schedule_rounded,
            'Dipesan',
            _formatDateTime(order.createdAt),
          ),
          _buildDetailRow(
            Icons.account_balance_wallet_rounded,
            'Ongkir',
            'Rp ${order.total ?? 0}',
          ),
          const SizedBox(height: 10),

          // Action: Update Status
          Row(
            children: [
              order.status == OrderStatus.onTheWay
                  ? Container()
                  : Expanded(
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.update_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              'Update Status',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: order.status.color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () =>
                                _showUpdateStatusDialog(context, order),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),

              IconButton(
                tooltip: 'WhatsApp Pelanggan',

                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () => _whatsappCustomer(order.phone),
              ),
              if (order.status == OrderStatus.pending ||
                  order.status == OrderStatus.confirmed ||
                  order.status == OrderStatus.pickingUp)
                IconButton(
                  tooltip: 'Buka Maps Jemput',
                  icon: const Icon(Icons.location_pin, color: Colors.blue),
                  onPressed: () => _openMaps(
                    order.latJemput,
                    order.lngJemput,
                    'Lokasi Jemput',
                  ),
                ),
              IconButton(
                tooltip: 'Buka Maps Antar',
                icon: const Icon(Icons.location_pin, color: Colors.purple),
                onPressed: () =>
                    _openMaps(order.latAntar, order.lngAntar, 'Lokasi Antar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  void _showUpdateStatusDialog(BuildContext context, OrderModel order) {
    final List<Map<String, dynamic>> statusOptions = [];

    // Status transition logic
    if (order.status == OrderStatus.pending) {
      statusOptions.add({
        'label': 'Konfirmasi Pesanan',
        'status': OrderStatus.confirmed,
        'color': Colors.blue,
      });
    }
    if (order.status == OrderStatus.confirmed) {
      statusOptions.add({
        'label': 'Mulai Pickup',
        'status': OrderStatus.pickingUp,
        'color': Colors.purple,
      });
    }
    if (order.status == OrderStatus.pickingUp) {
      statusOptions.add({
        'label': 'Dalam Perjalanan',
        'status': OrderStatus.onTheWay,
        'color': Colors.green,
      });
    }
    if (order.status == OrderStatus.onTheWay) {
      statusOptions.add({
        'label': 'Selesaikan Pesanan',
        'status': OrderStatus.delivered,
        'color': Colors.teal,
      });
    }
    if (order.status == OrderStatus.pending ||
        order.status == OrderStatus.confirmed) {
      statusOptions.add({
        'label': 'Batalkan Pesanan',
        'status': OrderStatus.cancelled,
        'color': Colors.red,
      });
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Text(
            'Update Status Pesanan',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          ...statusOptions.map(
            (opt) => ListTile(
              leading: Icon(Icons.check_circle, color: opt['color']),
              title: Text(opt['label']),
              onTap: () {
                Navigator.of(context).pop();
                this.context.read<KurirTrackingCubit>().updateOrderStatus(
                  order.id,
                  opt['status'],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _whatsappCustomer(String phone) async {
    final wa = phone.replaceAll(RegExp(r'^0'), '62'); // ubah 08xxx jadi 628xxx
    final uri = Uri.parse('https://wa.me/$wa');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openMaps(String? lat, String? lng, String label) async {
    if (lat == null || lng == null) return;
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
