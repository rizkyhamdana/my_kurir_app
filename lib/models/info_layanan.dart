class InfoLayananModel {
  final String jamOperasional;
  final String kontak;
  final String pengumuman;

  InfoLayananModel({
    required this.jamOperasional,
    required this.kontak,
    required this.pengumuman,
  });

  factory InfoLayananModel.fromFirestore(Map<String, dynamic> data) {
    return InfoLayananModel(
      jamOperasional: data['jamOperasional'] ?? '-',
      kontak: data['kontak'] ?? '-',
      pengumuman: data['pengumuman'] ?? '-',
    );
  }
}
