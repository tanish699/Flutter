import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<bool> login(String username, String password) async {
    try {
      final response = await _dio.post(
        "https://dummyjson.com/auth/login",
        data: {
          "username": username,
          "password": password,
          "expiresInMins": 30
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final prefs = await SharedPreferences.getInstance();

        // ✅ Save token
        await prefs.setString("accessToken", data["accessToken"]);

        // ✅ Save user data
        await prefs.setString("firstName", data["firstName"]);
        await prefs.setString("lastName", data["lastName"]);
        await prefs.setString("email", data["email"]);
        await prefs.setString("phone",     data["phone"] ?? "");
        await prefs.setString("birthDate", data["birthDate"] ?? "");
        await prefs.setString("gender",    data["gender"] ?? "");
        await prefs.setString("country",   data["address"]?["country"] ?? "");

        return true;
      }
    } catch (e) {
      print("Login Error: $e");
    }

    return false;
  }

  //Register
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {

    try {

      final response = await _dio.post(
        "https://dummyjson.com/users/add",

        data: {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        return true;
      }

    } catch (e) {

      print("Register Error: $e");
    }

    return false;
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");
    if (token == null) return null;

    try {
      final response = await _dio.get(
        "https://dummyjson.com/auth/me",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (response.statusCode == 200) return response.data;
    } catch (e) {
      print("GetUser Error: $e");
    }
    return null;
  }

}