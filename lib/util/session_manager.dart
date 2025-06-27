import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _keyUserId = 'userId';
  static const _keyRole = 'role';
  static const _keyLoginTimestamp = 'loginTimestamp';
  static const _keyOnboarding = 'isOnboardingShown';
  static const _keyFcmToken = 'fcmToken';
  static const _userName = 'userName';
  static const _userPhone = 'userPhone';

  static Future<void> saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userName, userName);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userName);
  }

  static Future<void> saveUserPhone(String userPhone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPhone, userPhone);
  }

  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPhone);
  }

  static Future<void> saveFcmToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFcmToken, token);
  }

  static Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFcmToken);
  }

  static Future<bool> isOnboardingShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboarding) ?? false;
  }

  static Future<void> setOnboardingShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboarding, true);
  }

  // Simpan session login
  static Future<void> saveLoginSession(String userId, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyRole, role);
    await prefs.setInt(
      _keyLoginTimestamp,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Cek apakah session masih valid (kurang dari 1 hari)
  static Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTimestamp = prefs.getInt(_keyLoginTimestamp);
    if (loginTimestamp == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch;
    return now - loginTimestamp < 86400000; // 1 hari = 86400000 ms
  }

  // Ambil role user
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  // Hapus session (logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyLoginTimestamp);
  }

  // Simpan userId
  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  // Ambil userId
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }
}
