import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderModel {
  final String id;
  final String userId;
  final String? courierId;
  final String nama;
  final String? kurirName;
  final String? kurirPhone;
  final String phone;
  final String alamatJemput;
  final String alamatAntar;
  final String jenisBarang;
  final String? catatan;
  final bool isUrgent;
  final DateTime createdAt;
  final OrderStatus status;
  final DateTime? confirmedAt;
  final DateTime? pickingUpAt;
  final DateTime? onTheWayAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;
  final String? latJemput;
  final String? lngJemput;
  final String? latAntar;
  final String? lngAntar;
  final int? total;

  OrderModel({
    required this.userId,
    this.courierId,
    this.confirmedAt,
    this.pickingUpAt,
    this.onTheWayAt,
    this.deliveredAt,
    this.cancelledAt,
    this.latJemput,
    this.lngJemput,
    this.latAntar,
    this.lngAntar,
    required this.id,
    required this.nama,
    this.kurirName,
    this.kurirPhone,
    required this.phone,
    required this.alamatJemput,
    required this.alamatAntar,
    required this.jenisBarang,
    this.catatan,
    required this.isUrgent,
    required this.createdAt,
    this.status = OrderStatus.pending,
    this.total,
  });

  /// Konversi dari Firestore
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime? toDate(dynamic ts) {
      if (ts == null) return null;
      if (ts is Timestamp) return ts.toDate();
      return DateTime.tryParse(ts.toString());
    }

    OrderStatus statusFromString(String? str) {
      return OrderStatus.values.firstWhere(
        (e) => e.name == str,
        orElse: () => OrderStatus.pending,
      );
    }

    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      courierId: data['courierId'],
      nama: data['nama'] ?? '',
      kurirName: data['kurirName'],
      kurirPhone: data['kurirPhone'],
      phone: data['phone'] ?? '',
      alamatJemput: data['alamatJemput'] ?? '',
      alamatAntar: data['alamatAntar'] ?? '',
      jenisBarang: data['jenisBarang'] ?? '',
      latJemput: data['latJemput'],
      lngJemput: data['lngJemput'],
      latAntar: data['latAntar'],
      lngAntar: data['lngAntar'],
      catatan: data['catatan'],
      isUrgent: data['isUrgent'] ?? false,
      createdAt: toDate(data['createdAt']) ?? DateTime.now(),
      confirmedAt: toDate(data['confirmedAt']),
      pickingUpAt: toDate(data['pickingUpAt']),
      onTheWayAt: toDate(data['onTheWayAt']),
      deliveredAt: toDate(data['deliveredAt']),
      cancelledAt: toDate(data['cancelledAt']),
      status: statusFromString(data['status']),
      total: data['total'] != null ? (data['total'] as num).toInt() : null,
    );
  }

  /// Konversi ke Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nama': nama,
      'kurirName': kurirName,
      'kurirPhone': kurirPhone,
      'phone': phone,
      'alamatJemput': alamatJemput,
      'alamatAntar': alamatAntar,
      'jenisBarang': jenisBarang,
      'catatan': catatan,
      'isUrgent': isUrgent,
      'createdAt': Timestamp.fromDate(createdAt),
      'userId': userId,
      'courierId': courierId,
      'latJemput': latJemput,
      'lngJemput': lngJemput,
      'latAntar': latAntar,
      'lngAntar': lngAntar,
      'confirmedAt': confirmedAt != null
          ? Timestamp.fromDate(confirmedAt!)
          : null,
      'pickingUpAt': pickingUpAt != null
          ? Timestamp.fromDate(pickingUpAt!)
          : null,
      'onTheWayAt': onTheWayAt != null ? Timestamp.fromDate(onTheWayAt!) : null,
      'deliveredAt': deliveredAt != null
          ? Timestamp.fromDate(deliveredAt!)
          : null,
      'cancelledAt': cancelledAt != null
          ? Timestamp.fromDate(cancelledAt!)
          : null,
      'status': status.name,
      'total': total ?? 0,
    };
  }

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
      userId: json['userId'],
      courierId: json['courierId'],
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
