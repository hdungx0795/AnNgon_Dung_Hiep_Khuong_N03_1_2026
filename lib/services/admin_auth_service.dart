class AdminAuthService {
  static const String adminEmail = 'admin@anngon.local';
  static const String adminPassword = 'admin123';

  bool validateCredentials(String email, String password) {
    return email.trim().toLowerCase() == adminEmail &&
        password == adminPassword;
  }
}
