import '../database/database_helper.dart';
import 'package:registration_flow/services/passEncryptor.dart';


class AuthService {
  final db = DataBaseHelper.instance;

  /// Login method
  Future<bool> login(String email, String password) async {
    // 1. Get user by email
    final user = await db.getUserByEmail(email);
    if (user == null) {
      return false; // user not found
    }

    // 2. Hash entered password
    final hashedInput = HashUtil.hashPassword(password);

    // 3. Compare with stored hash
    if (user['password'] == hashedInput) {
      return true;
    } else {
      return false;
    }
  }
}