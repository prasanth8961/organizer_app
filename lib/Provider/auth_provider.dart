import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organizer_app/Helper/api_service.dart';
import 'package:organizer_app/PageRouter/page_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<String> signUp(Map<String, dynamic> formData, List<dynamic> imagePaths,
      String? fileData) async {
    isLoading = true;
    errorMessage = null;

    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse("$baseUrl${Config.register}"));

      if (fileData != null) {
        request.files
            .add(await http.MultipartFile.fromPath('org-noc', fileData));
      }

      for (var imagePath in imagePaths) {
        request.files
            .add(await http.MultipartFile.fromPath('org-id-card', imagePath));
      }

      request.fields['data'] = jsonEncode(formData);

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(responseString);
        String accessToken = responseJson['accessToken'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        Get.offAllNamed(PageRoutes.mainScreen);
        return 'sign up success';
      } else {
        return 'Failed to sign up';
      }
    } catch (e) {
      return "internal server error";
    } finally {
      isLoading = false;
    }
  }

  Future<String> login(String email, String password) async {
    isLoading = true;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl${Config.loginUser}"),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', responseJson['accessToken']);
        return responseJson['message'];
      } else {
        return responseJson["message"];
      }
    } catch (e) {
      return 'Login failed';
    } finally {
      isLoading = false;
    }
  }
}
