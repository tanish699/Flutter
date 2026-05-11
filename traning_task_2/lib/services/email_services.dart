import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../config/secrets.dart';

class EmailService {

  static const String clientId = Secrets.clientId;

  static const String clientSecret = Secrets.clientSecret;

  static const String refreshToken = Secrets.refreshToken;

  // ================= GET ACCESS TOKEN =================

  Future<String?> getAccessToken() async {
    final response = await http.post(

      Uri.parse(
        "https://oauth2.googleapis.com/token",
      ),

      body: {

        "client_id": clientId,
        "client_secret": clientSecret,
        "refresh_token": refreshToken,
        "grant_type": "refresh_token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["access_token"];
    }

    return null;
  }

  // ================= SEND EMAIL =================

  Future<bool> sendOtpEmail({

    required String toEmail,
    required String otp,

  }) async {
    try {
      final accessToken = await getAccessToken();

      if (accessToken == null) {
        debugPrint("Access Token NULL");
        return false;
      }

      // ================= EMAIL BODY =================

      String email =
          "From: Me <tanishwadhwa2310@gmail.com>\r\n"
          "To: $toEmail\r\n"
          "Subject: Verification Code\r\n"
          "\r\n"
          "Your OTP is: $otp";

      // ================= ENCODE =================

      String encodedEmail = base64Url.encode(utf8.encode(email)).replaceAll("=", "");

      // ================= API CALL =================

      final response = await http.post(

        Uri.parse(

          "https://gmail.googleapis.com/gmail/v1/users/me/messages/send",

        ),

        headers: {

          "Authorization": "Bearer $accessToken",

          "Content-Type": "application/json",

        },

        body: jsonEncode({

          "raw": encodedEmail,

        }),

      );

      debugPrint("EMAIL RESPONSE:");

      debugPrint(response.body);

      debugPrint("STATUS CODE:");

      debugPrint('$response.statusCode');

      return response.statusCode == 200;
    } catch (e) {
      print("EMAIL ERROR: $e");

      return false;
    }
  }
}