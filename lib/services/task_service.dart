import 'dart:convert';
import 'package:flutter/foundation.dart'; 
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/task.dart';

class TaskService {
  Future<List<Task>> getTasks() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}?select=*&order=deadline.asc'),
      headers: AppConfig.headers,
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      // Debug error GET
      debugPrint("GET Error: ${response.statusCode} - ${response.body}");
      throw Exception('Gagal memuat tugas: ${response.statusCode}');
    }
  }

  Future<void> addTask(Task task) async {
    // Debug data yang dikirim
    debugPrint("Sending Data: ${json.encode(task.toJson())}");

    final response = await http.post(
      Uri.parse(AppConfig.baseUrl),
      headers: AppConfig.headers,
      body: json.encode(task.toJson()),
    );

    // Debug respon server
    debugPrint("POST Response Code: ${response.statusCode}");
    debugPrint("POST Response Body: ${response.body}");

    if (response.statusCode != 201) {
      // Ubah pesan error agar menampilkan alasan dari server
      throw Exception('Gagal menambah tugas: ${response.body}');
    }
  }

  Future<void> updateTask(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('${AppConfig.baseUrl}?id=eq.$id'),
      headers: AppConfig.headers,
      body: json.encode(data),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      debugPrint("PATCH Error: ${response.body}");
      throw Exception('Gagal update tugas: ${response.body}');
    }
  }
}