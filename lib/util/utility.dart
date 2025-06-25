class Utility {
  // This class is a placeholder for utility functions.
  // Add your utility methods here.

  static String formatDate(DateTime date) {
    // Example utility function to format a date
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String capitalize(String text) {
    // Example utility function to capitalize the first letter of a string
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String phoneToEmail(String phone) {
    // Hilangkan + jika ada, lalu tambahkan domain khusus
    final cleanPhone = phone.replaceAll('+', '');
    return '$cleanPhone@kuriratapange.app';
  }
}
