import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:frontend/common/urls.dart';
import 'package:frontend/data/models/task.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TaskSource {
  /// `'${URLs.host}/tasks'`
  static const _baseUrl = '${URLs.host}/tasks';

  static Future<bool> add(
      String title, String description, String dueDate, int userId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: jsonEncode({
          "title": title,
          "description": description,
          "status": "Queue",
          "dueDate": dueDate,
          "userId": userId
        }),
      );
      DMethod.logResponse(response);
      return response.statusCode == 201;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<bool> delete(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$id'),
      );
      DMethod.logResponse(response);
      return response.statusCode == 200;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<bool> submit(int id, XFile xfile) async {
    try {
      final request = http.MultipartRequest(
        "PATCH",
        Uri.parse('$_baseUrl/$id/submit'),
      )
        ..fields['submitDate'] = DateTime.now().toIso8601String()
        ..files.add(
          await http.MultipartFile.fromPath("attachment", xfile.path,
              filename: xfile.name),
        );
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<bool> reject(int id, String reason) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/$id/reject'),
        body: {
          "reason": reason,
          "rejectedDate": DateTime.now().toIso8601String(),
        },
      );
      DMethod.logResponse(response);
      return response.statusCode == 200;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<bool> fixToQueue(int id, int revision) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/$id/fix'),
        body: {"revision": revision},
      );
      DMethod.logResponse(response);
      return response.statusCode == 200;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<bool> approve(int id) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/$id/approve'),
        body: {
          "approvedDate": DateTime.now().toIso8601String(),
        },
      );
      DMethod.logResponse(response);
      return response.statusCode == 200;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return false;
    }
  }

  static Future<Task?> findById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
      );
      DMethod.logResponse(response);
      if (response.statusCode != 200) return null;
      Map resBody = jsonDecode(response.body);
      return Task.fromJson(Map.from(resBody));
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }

  static Future<List<Task>?> needToBeReviewed() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/review/asc'),
      );
      DMethod.logResponse(response);
      if (response.statusCode != 200) return null;
      List resBody = jsonDecode(response.body);
      return resBody
          .map((e) => Task.fromJson(
                Map.from(e),
              ))
          .toList();
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }

  static Future<List<Task>?> progress(int userId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/progress/$userId'));
      DMethod.logResponse(response);
      if (response.statusCode != 200) return null;
      List resBody = jsonDecode(response.body);
      return resBody
          .map((e) => Task.fromJson(
                Map.from(e),
              ))
          .toList();
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }

  static Future<Map?> statistic(int userId) async {
    List listStatus = ["Queue", "Review", "Approved", "Rejected"];
    Map stat = {};

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/stat/$userId'),
      );
      DMethod.logResponse(response);
      if (response.statusCode != 200) return null;
      List resBody = jsonDecode(response.body);
      for (String status in listStatus) {
        Map? found = resBody.where((e) => e['status' == status]).firstOrNull;
        stat[status] = found?['total'] ?? 0;
      }
      return stat;
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }

  static Future<List<Task>?> whereUserAndStatus(
      int userId, String status) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/$userId/$status"),
      );
      DMethod.logResponse(response);
      if (response.statusCode != 200) return null;
      List resBody = jsonDecode(response.body);
      return resBody
          .map((e) => Task.fromJson(
                Map.from(e),
              ))
          .toList();
    } catch (e) {
      DMethod.log(e.toString(), colorCode: 1);
      return null;
    }
  }
}
