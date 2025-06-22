import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';

class OnboardingData {
  static List<OnboardingModel> getOnboardingData() {
    return [
      OnboardingModel(
        title: "Selamat Datang di",
        subtitle: "Kurir Atapange",
        description:
            "Solusi pengiriman terpercaya untuk desa Anda. Kirim barang dengan mudah, cepat, dan aman langsung ke rumah.",
        icon: "🚀",
        gradientColors: [const Color(0xFF667eea), const Color(0xFF764ba2)],
      ),
      OnboardingModel(
        title: "Lacak Pesanan",
        subtitle: "Real-time Tracking",
        description:
            "Pantau status pengiriman secara real-time. Dapatkan notifikasi langsung untuk setiap update pesanan Anda.",
        icon: "📍",
        gradientColors: [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      ),
      OnboardingModel(
        title: "Layanan 24/7",
        subtitle: "Siap Melayani",
        description:
            "Kami melayani pengiriman 24 jam sehari, 7 hari seminggu dengan harga terjangkau mulai dari Rp 3.000.",
        icon: "⏰",
        gradientColors: [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      ),
    ];
  }
}
