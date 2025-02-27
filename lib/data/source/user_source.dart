import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:frontend/common/urls.dart';
import 'package:frontend/data/models/user.dart';
import 'package:http/http.dart' as http;

class UserSource {
  /// `'${URLs.host}/users'`
  static const _baseUrl = '${URLs.host}/users';

  static Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      DMethod.logResponse(response);
      if (response.statusCode != 200) return null;
      Map resBody = jsonDecode(response.body);
      return User.fromJson(Map.from(resBody));
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }

  static Future<bool> addEmployee(String name, String email) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: jsonEncode({
          "name": name,
          "email": email,
        }),
      );
      DMethod.logResponse(response);
      return response.statusCode == 201;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<bool> delete(int userId) async {
    try {
      final response = await http.post(Uri.parse('$_baseUrl/$userId'));
      DMethod.logResponse(response);
      return response.statusCode == 200;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<List<User>?> getEmployee() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/Employee'));
      DMethod.logResponse(response);
      if (response.statusCode != 200) return null;
      List resBody = jsonDecode(response.body);
      return resBody.map((e) => User.fromJson(Map.from(e))).toList();
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }
}
