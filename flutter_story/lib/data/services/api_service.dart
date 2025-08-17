import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../../core/constant.dart'; // Import AppConstants
import '../models/story_model.dart';

class ApiService {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == false) {
          return User.fromJson(data['loginResult']);
        } else {
          throw Exception(data['message'] ?? 'Login failed');
        }
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['error'] == false;
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Story>> getStories(String token,
      {int page = 1, int size = AppConstants.pageSize}) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'size': size.toString(),
      };
      final response = await http.get(
        Uri.parse('$baseUrl/stories').replace(queryParameters: queryParameters),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == false) {
          final List<dynamic> storiesJson = data['listStory'];
          return storiesJson.map((json) => Story.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to get stories');
        }
      } else {
        throw Exception('Failed to get stories');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> addStory(String token, String description, File imageFile,
      {double? lat, double? lon}) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/stories'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['description'] = description;
      if (lat != null) {
        request.fields['lat'] = lat.toString();
      }
      if (lon != null) {
        request.fields['lon'] = lon.toString();
      }
      request.files.add(
        await http.MultipartFile.fromPath('photo', imageFile.path),
      );

      final response = await request.send();

      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        return data['error'] == false;
      } else {
        final responseData = await response.stream.bytesToString();
        try {
          final data = jsonDecode(responseData);
          throw Exception(data['message'] ??
              'Failed to upload story. Status code: ${response.statusCode}');
        } catch (_) {
          throw Exception(
              'Failed to upload story. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      log('$e');
      rethrow;
    }
  }
}
