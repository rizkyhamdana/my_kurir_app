import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../models/order_model.dart';
import '../../widgets/glass_container.dart';
import 'dart:ui';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alamatJemputController = TextEditingController();
  final _alamatAntarController = TextEditingController();
  final _catatanController = TextEditingController();

  String _jenisBarang = 'Makanan/Minuman';
  bool _isUrgent = false;

  @override
  Widget build(BuildContext context) {
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
                        'Pesan Kurir Desa',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Section
                        GlassContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF667eea),
                                      Color(0xFF764ba2),
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
                              const Text(
                                'Kurir Desa Siap Membantu!',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Pesan barang di grup WA? Kami antar sampai rumah dengan aman dan cepat',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withAlpha(179),
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Data Pemesan Section
                        _buildSectionTitle('👤 Data Pemesan'),
                        const SizedBox(height: 15),

                        _buildModernTextField(
                          controller: _namaController,
                          label: 'Nama Lengkap',
                          icon: Icons.person_rounded,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama harus diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildModernTextField(
                          controller: _phoneController,
                          label: 'No. WhatsApp',
                          icon: Icons.phone_rounded,
                          hint: '08xxxxxxxxxx',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nomor WhatsApp harus diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Detail Pengiriman Section
                        _buildSectionTitle('📦 Detail Pengiriman'),
                        const SizedBox(height: 15),

                        _buildModernTextField(
                          controller: _alamatJemputController,
                          label: 'Alamat Jemput (Toko/Warung)',
                          icon: Icons.store_rounded,
                          hint: 'Contoh: Warung Bu Siti, Jl. Raya Desa',
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Alamat jemput harus diisi';
                            }
                            return null;
                          },
                          onPickLocation: () async {
                            final picked = await context.push<LatLng>(
                              '/pick-location',
                            );
                            if (picked != null) {
                              _alamatJemputController.text =
                                  'Lat: ${picked.latitude}, Lng: ${picked.longitude}';
                              setState(() {});
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildModernTextField(
                          controller: _alamatAntarController,
                          label: 'Alamat Antar (Rumah)',
                          icon: Icons.home_rounded,
                          hint: 'Contoh: Jl. Raya Desa No. 123',
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Alamat antar harus diisi';
                            }
                            return null;
                          },
                          onPickLocation: () async {
                            final picked = await context.push<LatLng>(
                              '/pick-location',
                            );
                            if (picked != null) {
                              _alamatAntarController.text =
                                  'Lat: ${picked.latitude}, Lng: ${picked.longitude}';
                              setState(() {});
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        // Dropdown Jenis Barang
                        GlassContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF00BCD4,
                                      ).withAlpha(51),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.category_rounded,
                                      color: Color(0xFF00BCD4),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Jenis Barang',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(26),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withAlpha(51),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _jenisBarang,
                                    isExpanded: true,
                                    dropdownColor: const Color(0xFF1D1E33),
                                    style: const TextStyle(color: Colors.white),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Makanan/Minuman',
                                        child: Text('🍔 Makanan/Minuman'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Obat-obatan',
                                        child: Text('💊 Obat-obatan'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Kebutuhan Harian',
                                        child: Text('🛒 Kebutuhan Harian'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Elektronik',
                                        child: Text('📱 Elektronik'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Pakaian',
                                        child: Text('👕 Pakaian'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Lainnya',
                                        child: Text('📦 Lainnya'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _jenisBarang = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildModernTextField(
                          controller: _catatanController,
                          label: 'Catatan Tambahan (Opsional)',
                          icon: Icons.note_rounded,
                          hint: 'Contoh: Barang sudah dibayar, tinggal ambil',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),

                        // Urgent Checkbox
                        GlassContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isUrgent = !_isUrgent;
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _isUrgent
                                        ? const Color(0xFFf5576c)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _isUrgent
                                          ? const Color(0xFFf5576c)
                                          : Colors.white.withAlpha(77),
                                      width: 2,
                                    ),
                                  ),
                                  child: _isUrgent
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '⚡ Pengiriman Urgent',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Tambahan biaya Rp 2.000 untuk prioritas',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withAlpha(179),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Info Tarif
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
                                          Color(0xFF4facfe),
                                          Color(0xFF00f2fe),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.info_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  const Text(
                                    'Informasi Tarif',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildTariffRow('🏘️', 'Dalam desa', 'Rp 3.000'),
                              _buildTariffRow('🌍', 'Antar desa', 'Rp 5.000'),
                              _buildTariffRow('⚡', 'Urgent', '+Rp 2.000'),
                              _buildTariffRow(
                                '💰',
                                'Pembayaran',
                                'Cash saat terima',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Submit Button
                        Container(
                          width: double.infinity,
                          height: 60,
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
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _submitOrder();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.rocket_launch_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Pesan Kurir Sekarang',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    VoidCallback? onPickLocation, // Tambahkan parameter ini
  }) {
    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BCD4).withAlpha(51),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF00BCD4), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (onPickLocation != null) ...[
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.location_pin,
                    color: Color(0xFF00BCD4),
                  ),
                  tooltip: 'Pilih lokasi dari peta',
                  onPressed: onPickLocation,
                ),
              ],
            ],
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withAlpha(130)),
              filled: true,
              fillColor: Colors.white.withAlpha(26),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white.withAlpha(51)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white.withAlpha(51)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Color(0xFF00BCD4),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Color(0xFFf5576c),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTariffRow(String emoji, String label, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
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
            price,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00BCD4),
            ),
          ),
        ],
      ),
    );
  }

  void _submitOrder() {
    final order = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: _namaController.text,
      phone: _phoneController.text,
      alamatJemput: _alamatJemputController.text,
      alamatAntar: _alamatAntarController.text,
      jenisBarang: _jenisBarang,
      catatan: _catatanController.text.isEmpty ? null : _catatanController.text,
      isUrgent: _isUrgent,
      createdAt: DateTime.now(),
    );

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
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Pesanan Berhasil!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Pesanan Anda telah diterima. Kurir akan segera menghubungi Anda via WhatsApp untuk konfirmasi.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withAlpha(204),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
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
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.pushReplacement('/tracking', extra: order);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Lacak Pesanan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  @override
  void dispose() {
    _namaController.dispose();
    _phoneController.dispose();
    _alamatJemputController.dispose();
    _alamatAntarController.dispose();
    _catatanController.dispose();
    super.dispose();
  }
}
