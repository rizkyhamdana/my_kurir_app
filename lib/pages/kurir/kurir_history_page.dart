import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/glass_container.dart';
import 'dart:ui';

class KurirHistoryPage extends StatelessWidget {
  const KurirHistoryPage({super.key});

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
                    // Filter Button
                    GlassContainer(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.filter_list_rounded,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Statistics Summary
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
                            Text(
                              '127 Pesanan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
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
                          color: const Color(0xFF43e97b).withAlpha(51),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '+12 Hari ini',
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
              ),

              const SizedBox(height: 20),

              // History List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _getHistoryData().length,
                  itemBuilder: (context, index) {
                    final historyItem = _getHistoryData()[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: GlassContainer(
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
                                          historyItem['gradient']
                                              as List<Color>,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            (historyItem['gradient']
                                                    as List<Color>)
                                                .first
                                                .withAlpha(77),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    historyItem['icon'] as IconData,
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
                                        historyItem['title'] as String,
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
                                        historyItem['orderId'] as String,
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white.withAlpha(179)
                                              : Colors.black87.withAlpha(179),
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
                                    color: (historyItem['statusColor'] as Color)
                                        .withAlpha(51),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    historyItem['status'] as String,
                                    style: TextStyle(
                                      color:
                                          historyItem['statusColor'] as Color,
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
                                    'Alamat',
                                    historyItem['address'] as String,
                                  ),
                                  const SizedBox(height: 10),
                                  _buildDetailRow(
                                    context,
                                    Icons.schedule_rounded,
                                    'Waktu Selesai',
                                    historyItem['completedTime'] as String,
                                  ),
                                  const SizedBox(height: 10),
                                  _buildDetailRow(
                                    context,
                                    Icons.account_balance_wallet_rounded,
                                    'Pendapatan',
                                    historyItem['earning'] as String,
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
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _showOrderDetails(context, historyItem);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _showContactCustomer(
                                          context,
                                          historyItem,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                      ),
                    );
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

  List<Map<String, dynamic>> _getHistoryData() {
    return [
      {
        'title': 'Pesanan Selesai #001',
        'orderId': 'ORD-2025-001',
        'address': 'Jl. Merdeka No. 123, Atapange',
        'completedTime': '21 Jan 2025, 14:30',
        'earning': 'Rp 15.000',
        'status': 'Selesai',
        'statusColor': const Color(0xFF43e97b),
        'icon': Icons.check_circle_rounded,
        'gradient': [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
        'customerName': 'Ibu Sari',
        'customerPhone': '0812-3456-7890',
      },
      {
        'title': 'Pesanan Selesai #002',
        'orderId': 'ORD-2025-002',
        'address': 'Jl. Sudirman No. 45, Atapange',
        'completedTime': '21 Jan 2025, 13:15',
        'earning': 'Rp 12.000',
        'status': 'Selesai',

        'statusColor': const Color(0xFF43e97b),
        'icon': Icons.check_circle_rounded,
        'gradient': [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
        'customerName': 'Pak Budi',
        'customerPhone': '0813-4567-8901',
      },
      {
        'title': 'Pesanan Dibatalkan #003',
        'orderId': 'ORD-2025-003',
        'address': 'Jl. Diponegoro No. 78, Atapange',
        'completedTime': '20 Jan 2025, 16:45',
        'earning': 'Rp 0',
        'status': 'Dibatalkan',
        'statusColor': const Color(0xFFf5576c),
        'icon': Icons.cancel_rounded,
        'gradient': [const Color(0xFFf093fb), const Color(0xFFf5576c)],
        'customerName': 'Ibu Rina',
        'customerPhone': '0814-5678-9012',
      },
      {
        'title': 'Pesanan Selesai #004',
        'orderId': 'ORD-2025-004',
        'address': 'Jl. Ahmad Yani No. 90, Atapange',
        'completedTime': '20 Jan 2025, 11:20',
        'earning': 'Rp 18.000',
        'status': 'Selesai',
        'statusColor': const Color(0xFF43e97b),
        'icon': Icons.check_circle_rounded,
        'gradient': [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
        'customerName': 'Pak Ahmad',
        'customerPhone': '0815-6789-0123',
      },
      {
        'title': 'Pesanan Selesai #005',
        'orderId': 'ORD-2025-005',
        'address': 'Jl. Kartini No. 12, Atapange',
        'completedTime': '19 Jan 2025, 15:30',
        'earning': 'Rp 10.000',
        'status': 'Selesai',
        'statusColor': const Color(0xFF43e97b),
        'icon': Icons.check_circle_rounded,
        'gradient': [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
        'customerName': 'Ibu Maya',
        'customerPhone': '0816-7890-1234',
      },
    ];
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
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
                      colors: order['gradient'] as List<Color>,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    order['icon'] as IconData,
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
                        _buildDetailItem(
                          context,
                          'ID Pesanan',
                          order['orderId'],
                        ),
                        _buildDetailItem(
                          context,
                          'Pelanggan',
                          order['customerName'],
                        ),
                        _buildDetailItem(
                          context,
                          'No. Telepon',
                          order['customerPhone'],
                        ),
                        _buildDetailItem(
                          context,
                          'Alamat Tujuan',
                          order['address'],
                        ),
                        _buildDetailItem(
                          context,
                          'Waktu Selesai',
                          order['completedTime'],
                        ),
                        _buildDetailItem(
                          context,
                          'Pendapatan',
                          order['earning'],
                        ),
                        _buildDetailItem(context, 'Status', order['status']),
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

  void _showContactCustomer(BuildContext context, Map<String, dynamic> order) {
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
                  order['customerName'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  order['customerPhone'],
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
                            // TODO: Implement WhatsApp call
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
                            // TODO: Implement phone call
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
}
