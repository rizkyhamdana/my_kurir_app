class TariffModel {
  final int dalamDesa;
  final int antarDesa;
  final int urgent;

  TariffModel({
    required this.dalamDesa,
    required this.antarDesa,
    required this.urgent,
  });

  factory TariffModel.fromFirestore(Map<String, dynamic> data) {
    return TariffModel(
      dalamDesa: data['dalamDesa'] ?? 0,
      antarDesa: data['antarDesa'] ?? 0,
      urgent: data['urgent'] ?? 0,
    );
  }
}
