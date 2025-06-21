import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/order_model.dart';
import '../../widgets/glass_container.dart';
import 'dart:ui';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  String _selectedFilter = 'Semua';
  final List<String> _filterOptions = [
    'Semua',
    'Selesai',
    'Dibatalkan',
    'Dalam Proses',
  ];

  // Dummy data untuk history
  late List<OrderModel> _historyOrders;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _initializeDummyData();
    _controller.forward();
  }

  void _initializeDummyData() {
    _historyOrders = [
      OrderModel(
        id: 'ORD-001',
        nama: 'Budi Santoso',
        phone: '+62 812-3456-7890',
        alamatJemput: 'Warung Bu Siti, Jl. Raya Desa No. 15',
        alamatAntar: 'Jl. Melati No. 8, RT 03/RW 01',
        jenisBarang: 'Makanan/Minuman',
        catatan: 'Sudah dibayar via transfer',
        isUrgent: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        status: OrderStatus.delivered,
      ),
      OrderModel(
        id: 'ORD-002',
        nama: 'Siti Aminah',
        phone: '+62 813-9876-5432',
        alamatJemput: 'Toko Kelontong Pak Joko, Jl. Mawar No. 20',
        alamatAntar: 'Jl. Anggrek No. 12, RT 02/RW 03',
        jenisBarang: 'Kebutuhan Harian',
        catatan: 'Tolong beli sabun cuci dan deterjen',
        isUrgent: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        status: OrderStatus.delivered,
      ),
      OrderModel(
        id: 'ORD-003',
        nama: 'Ahmad Fauzi',
        phone: '+62 814-1234-5678',
        alamatJemput: 'Apotek Sehat, Jl. Kesehatan No. 5',
        alamatAntar: 'Jl. Dahlia No. 25, RT 01/RW 02',
        jenisBarang: 'Obat-obatan',
        catatan: 'Obat untuk ibu, sudah ada resep',
        isUrgent: false,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        status: OrderStatus.cancelled,
      ),
      OrderModel(
        id: 'ORD-004',
        nama: 'Dewi Lestari',
        phone: '+62 815-5555-6666',
        alamatJemput: 'Toko Elektronik Maju, Jl. Teknologi No. 10',
        alamatAntar: 'Jl. Cempaka No. 18, RT 04/RW 01',
        jenisBarang: 'Elektronik',
        catatan: 'Charger HP Samsung',
        isUrgent: false,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        status: OrderStatus.delivered,
      ),
      OrderModel(
        id: 'ORD-005',
        nama: 'Rizki Pratama',
        phone: '+62 816-7777-8888',
        alamatJemput: 'Warung Makan Sederhana, Jl. Rasa No. 7',
        alamatAntar: 'Jl. Kenanga No. 30, RT 05/RW 02',
        jenisBarang: 'Makanan/Minuman',
        catatan: 'Nasi gudeg 2 porsi',
        isUrgent: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        status: OrderStatus.onTheWay,
      ),
      OrderModel(
        id: 'ORD-006',
        nama: 'Maya Sari',
        phone: '+62 817-9999-0000',
        alamatJemput: 'Toko Baju Fashion, Jl. Mode No. 15',
        alamatAntar: 'Jl. Flamboyan No. 22, RT 03/RW 04',
        jenisBarang: 'Pakaian',
        catatan: 'Baju anak ukuran M',
        isUrgent: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.delivered,
      ),
    ];
  }

  List<OrderModel> get _filteredOrders {
    if (_selectedFilter == 'Semua') return _historyOrders;

    switch (_selectedFilter) {
      case 'Selesai':
        return _historyOrders
            .where((order) => order.status == OrderStatus.delivered)
            .toList();
      case 'Dibatalkan':
        return _historyOrders
            .where((order) => order.status == OrderStatus.cancelled)
            .toList();
      case 'Dalam Proses':
        return _historyOrders
            .where(
              (order) =>
                  order.status == OrderStatus.pending ||
                  order.status == OrderStatus.confirmed ||
                  order.status == OrderStatus.onTheWay,
            )
            .toList();
      default:
        return _historyOrders;
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
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

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
                          'Riwayat Pesanan',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: _showFilterDialog,
                      //   child: GlassContainer(
                      //     width: 50,
                      //     height: 50,
                      //     padding: const EdgeInsets.all(12),
                      //     child: Icon(
                      //       Icons.filter_list_rounded,
                      //       color: textColor,
                      //       size: 24,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                // Filter Chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filterOptions.length,
                      itemBuilder: (context, index) {
                        final filter = _filterOptions[index];
                        final isSelected = _selectedFilter == filter;

                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFF667eea),
                                          Color(0xFF764ba2),
                                        ],
                                      )
                                    : null,
                                color: isSelected
                                    ? null
                                    : (isDarkMode
                                          ? Colors.white.withAlpha(26)
                                          : Colors.black.withAlpha(10)),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : (isDarkMode
                                            ? Colors.white.withAlpha(51)
                                            : Colors.black.withAlpha(20)),
                                ),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : textColor,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Statistics Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        _buildStatItem(
                          'Total Pesanan',
                          _historyOrders.length.toString(),
                          Icons.receipt_long_rounded,
                          const Color(0xFF4facfe),
                        ),
                        const SizedBox(width: 20),
                        _buildStatItem(
                          'Selesai',
                          _historyOrders
                              .where((o) => o.status == OrderStatus.delivered)
                              .length
                              .toString(),
                          Icons.check_circle_rounded,
                          const Color(0xFF43e97b),
                        ),
                        const SizedBox(width: 20),
                        _buildStatItem(
                          'Dibatalkan',
                          _historyOrders
                              .where((o) => o.status == OrderStatus.cancelled)
                              .length
                              .toString(),
                          Icons.cancel_rounded,
                          const Color(0xFFf5576c),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Orders List
                Expanded(
                  child: _filteredOrders.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = _filteredOrders[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: _buildOrderCard(order),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: textColor.withAlpha(150)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return GestureDetector(
      onTap: () => _showOrderDetails(order),
      child: Container(
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
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.id,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDateTime(order.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withAlpha(140),
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
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: order.status.color.withAlpha(77),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(order.status),
                          size: 14,
                          color: order.status.color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          order.status.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: order.status.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Customer Info
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4facfe).withAlpha(51),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Color(0xFF4facfe),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.nama,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        Text(
                          order.phone,
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withAlpha(150),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Item Info
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF43e97b).withAlpha(51),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getCategoryIcon(order.jenisBarang),
                      color: const Color(0xFF43e97b),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.jenisBarang,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        if (order.catatan != null && order.catatan!.isNotEmpty)
                          Text(
                            order.catatan!,
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withAlpha(150),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (order.isUrgent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFf5576c).withAlpha(51),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '⚡ Urgent',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFf5576c),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),

              // Address Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isDarkMode ? Colors.white : Colors.black).withAlpha(
                    10,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.store_rounded,
                          size: 16,
                          color: Color(0xFFffd700),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.alamatJemput,
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withAlpha(170),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 2,
                          decoration: BoxDecoration(
                            color: textColor.withAlpha(80),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_downward_rounded,
                          size: 12,
                          color: Color(0xFF00BCD4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.home_rounded,
                          size: 16,
                          color: Color(0xFF43e97b),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.alamatAntar,
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withAlpha(170),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: Rp ${order.totalCost}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00BCD4),
                    ),
                  ),
                  Row(
                    children: [
                      if (order.status == OrderStatus.onTheWay)
                        GestureDetector(
                          onTap: () => context.push('/tracking', extra: order),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Lacak',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showOrderDetails(order),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (isDarkMode ? Colors.white : Colors.black)
                                .withAlpha(26),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF667eea).withAlpha(51),
                    const Color(0xFF764ba2).withAlpha(26),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.history_rounded,
                size: 60,
                color: textColor.withAlpha(120),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Belum Ada Riwayat',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _selectedFilter == 'Semua'
                  ? 'Anda belum memiliki riwayat pesanan'
                  : 'Tidak ada pesanan dengan filter "$_selectedFilter"',
              style: TextStyle(fontSize: 16, color: textColor.withAlpha(150)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ElevatedButton(
                onPressed: () => context.push('/order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Pesan Sekarang',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
    );
  }

  // void _showFilterDialog() {
  //   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  //   final textColor =
  //       Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

  //   showDialog(
  //     context: context,
  //     builder: (context) => BackdropFilter(
  //       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //       child: Dialog(
  //         backgroundColor: Colors.transparent,
  //         child: GlassContainer(
  //           padding: const EdgeInsets.all(25),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 'Filter Pesanan',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: textColor,
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               ..._filterOptions.map((filter) {
  //                 final isSelected = _selectedFilter == filter;
  //                 return Padding(
  //                   padding: const EdgeInsets.only(bottom: 10),
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       setState(() {
  //                         _selectedFilter = filter;
  //                       });
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: Container(
  //                       width: double.infinity,
  //                       padding: const EdgeInsets.all(15),
  //                       decoration: BoxDecoration(
  //                         gradient: isSelected
  //                             ? const LinearGradient(
  //                                 colors: [
  //                                   Color(0xFF667eea),
  //                                   Color(0xFF764ba2),
  //                                 ],
  //                               )
  //                             : null,
  //                         color: isSelected
  //                             ? null
  //                             : (isDarkMode
  //                                   ? Colors.white.withAlpha(26)
  //                                   : Colors.black.withAlpha(10)),
  //                         borderRadius: BorderRadius.circular(12),
  //                         border: Border.all(
  //                           color: isSelected
  //                               ? Colors.transparent
  //                               : (isDarkMode
  //                                     ? Colors.white.withAlpha(51)
  //                                     : Colors.black.withAlpha(20)),
  //                         ),
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Icon(
  //                             _getFilterIcon(filter),
  //                             color: isSelected ? Colors.white : textColor,
  //                             size: 20,
  //                           ),
  //                           const SizedBox(width: 12),
  //                           Text(
  //                             filter,
  //                             style: TextStyle(
  //                               color: isSelected ? Colors.white : textColor,
  //                               fontWeight: isSelected
  //                                   ? FontWeight.bold
  //                                   : FontWeight.w500,
  //                             ),
  //                           ),
  //                           const Spacer(),
  //                           if (isSelected)
  //                             const Icon(
  //                               Icons.check_rounded,
  //                               color: Colors.white,
  //                               size: 20,
  //                             ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               }),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showOrderDetails(OrderModel order) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

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
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            order.status.color,
                            order.status.color.withAlpha(150),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        _getStatusIcon(order.status),
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
                            'Detail Pesanan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Text(
                            order.id,
                            style: TextStyle(
                              fontSize: 14,
                              color: order.status.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Order Details
                Container(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildDetailRow(
                          '📅',
                          'Tanggal Pesan',
                          _formatDateTime(order.createdAt),
                        ),
                        _buildDetailRow('👤', 'Nama Pemesan', order.nama),
                        _buildDetailRow('📱', 'No. HP', order.phone),
                        _buildDetailRow(
                          '🏪',
                          'Alamat Jemput',
                          order.alamatJemput,
                        ),
                        _buildDetailRow(
                          '🏠',
                          'Alamat Antar',
                          order.alamatAntar,
                        ),
                        _buildDetailRow(
                          '📦',
                          'Jenis Barang',
                          order.jenisBarang,
                        ),
                        if (order.catatan != null && order.catatan!.isNotEmpty)
                          _buildDetailRow('📝', 'Catatan', order.catatan!),
                        _buildDetailRow(
                          '⚡',
                          'Urgent',
                          order.isUrgent ? 'Ya' : 'Tidak',
                        ),
                        _buildDetailRow(
                          '💰',
                          'Total Ongkir',
                          'Rp ${order.totalCost}',
                        ),
                        _buildDetailRow(
                          '📊',
                          'Status',
                          order.status.displayName,
                          valueColor: order.status.color,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Action Buttons
                Row(
                  children: [
                    if (order.status == OrderStatus.onTheWay) ...[
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.push('/tracking', extra: order);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.track_changes_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Lacak Pesanan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _reorderDialog(order);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Pesan Lagi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.white.withAlpha(77)
                          : Colors.black.withAlpha(77),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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

  Widget _buildDetailRow(
    String emoji,
    String label,
    String value, {
    Color? valueColor,
  }) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor.withAlpha(170),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? textColor,
                fontSize: 14,
                fontWeight: valueColor != null
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _reorderDialog(OrderModel order) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

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
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Pesan Lagi?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Apakah Anda ingin memesan kurir dengan detail yang sama seperti pesanan sebelumnya?',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withAlpha(170),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.white.withAlpha(77)
                                : Colors.black.withAlpha(77),
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.push('/order');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Data pesanan telah diisi otomatis',
                                ),
                                backgroundColor: const Color(0xFF43e97b),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Ya, Pesan',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.schedule_rounded;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline_rounded;
      case OrderStatus.onTheWay:
        return Icons.delivery_dining_rounded;
      case OrderStatus.delivered:
        return Icons.check_circle_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_rounded;
      case OrderStatus.pickingUp:
        return Icons.cancel_rounded;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan/Minuman':
        return Icons.restaurant_rounded;
      case 'Obat-obatan':
        return Icons.medical_services_rounded;
      case 'Kebutuhan Harian':
        return Icons.shopping_cart_rounded;
      case 'Elektronik':
        return Icons.devices_rounded;
      case 'Pakaian':
        return Icons.checkroom_rounded;
      default:
        return Icons.inventory_rounded;
    }
  }

  // IconData _getFilterIcon(String filter) {
  //   switch (filter) {
  //     case 'Semua':
  //       return Icons.list_rounded;
  //     case 'Selesai':
  //       return Icons.check_circle_rounded;
  //     case 'Dibatalkan':
  //       return Icons.cancel_rounded;
  //     case 'Dalam Proses':
  //       return Icons.delivery_dining_rounded;
  //     default:
  //       return Icons.filter_list_rounded;
  //   }
  // }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Hari ini ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Kemarin ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
