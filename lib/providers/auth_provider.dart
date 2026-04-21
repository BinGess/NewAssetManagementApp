import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthNotifier extends Notifier<bool> {
  static const _passwordKey = 'admin_password';
  final _storage = const FlutterSecureStorage();

  @override
  bool build() => false; // Not authenticated by default

  Future<bool> login(String input) async {
    final stored = await _storage.read(key: _passwordKey);
    if (stored == null) {
      // First launch: store this password and log in
      await _storage.write(key: _passwordKey, value: input);
      state = true;
      return true;
    }
    final match = stored == input;
    state = match;
    return match;
  }

  Future<void> changePassword(String newPassword) async {
    await _storage.write(key: _passwordKey, value: newPassword);
  }

  Future<bool> hasPassword() async {
    return (await _storage.read(key: _passwordKey)) != null;
  }

  void logout() => state = false;
}

final authProvider = NotifierProvider<AuthNotifier, bool>(() {
  return AuthNotifier();
});
