import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organizer_app/Helper/api_service.dart';
import 'package:organizer_app/Model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider extends ChangeNotifier {
  List<UserModel> _userData = [];
  List<UserModel> get userData => _userData;

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("accessToken");

    if (token == null) {
      _userData = [];
      notifyListeners();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("$baseUrl${Config.getUserDetail}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBodyData = jsonDecode(response.body);
        print(jsonBodyData["data"]);
        _userData = List<UserModel>.from(
          (jsonBodyData["data"]).map((data) => UserModel.fromJson(data)),
        );
      } else {
        print('Failed to load user data');
        _userData = [];
      }
    } catch (e) {
      print('Error fetching user data: $e');
      _userData = [];
    }

    notifyListeners();
  }

  Future<String> updateProfileImage(File imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("accessToken");

    if (token == null) {
      notifyListeners();
      return 'No access token found';
    }

    try {
      final request = http.MultipartRequest(
          'POST',
          Uri.parse(
            "$baseUrl${Config.updateDetail}",
          ));
      request.files
          .add(await http.MultipartFile.fromPath('profile', imageFile.path));

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBodyData = jsonDecode(responseString);
        _userData = List<UserModel>.from(
          (jsonBodyData["data"]).map((data) => UserModel.fromJson(data)),
        );
        notifyListeners();
        return jsonBodyData["message"];
      }
      return jsonDecode(responseString)["message"];
    } catch (e) {
      notifyListeners();
      return 'Error : $e';
    }
  }
}
