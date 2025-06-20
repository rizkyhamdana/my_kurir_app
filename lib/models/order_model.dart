import 'package:flutter/material.dart';

class OrderModel {
  final String id;
  final String nama;
  final String phone;
  final String alamatJemput;
  final String alamatAntar;
  final String jenisBarang;
  final String? catatan;
  final bool isUrgent;
  final DateTime createdAt;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.nama,
    required this.phone,
    required this.alamatJemput,
    required this.alamatAntar,
    required this.jenisBarang,
    this.catatan,
    required this.isUrgent,
    required this.createdAt,
    this.status = OrderStatus.pending,
  });

  int get totalCost {
    int baseCost = 3000; // Tarif dasar
    if (isUrgent) baseCost += 2000;
    return baseCost;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'phone': phone,
      'alamatJemput': alamatJemput,
      'alamatAntar': alamatAntar,
      'jenisBarang': jenisBarang,
      'catatan': catatan,
      'isUrgent': isUrgent,
      'createdAt': createdAt.toIso8601String(),
      'status': status.toString(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      nama: json['nama'],
      phone: json['phone'],
      alamatJemput: json['alamatJemput'],
      alamatAntar: json['alamatAntar'],
      jenisBarang: json['jenisBarang'],
      catatan: json['catatan'],
      isUrgent: json['isUrgent'],
      createdAt: DateTime.parse(json['createdAt']),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => OrderStatus.pending,
      ),
    );
  }
}

enum OrderStatus {
  pending,
  confirmed,
  pickingUp,
  onTheWay,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Menunggu Konfirmasi';
      case OrderStatus.confirmed:
        return 'Dikonfirmasi';
      case OrderStatus.pickingUp:
        return 'Kurir Mengambil Barang';
      case OrderStatus.onTheWay:
        return 'Dalam Perjalanan';
      case OrderStatus.delivered:
        return 'Terkirim';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.pickingUp:
        return Colors.purple;
      case OrderStatus.onTheWay:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.teal;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
