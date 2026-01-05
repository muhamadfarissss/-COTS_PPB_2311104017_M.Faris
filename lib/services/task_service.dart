// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/task.dart';

// class TaskService {
//   static const String _baseUrl = 'https://rpblbedyqmnzpowbumzd.supabase.co/rest/v1/tasks';
//   // Token diambil dari dokumen PDF [cite: 133-134]
//   static const String _apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZCI6InJwYmxiZWR5cW1uenBvd2J1bXpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgxMjcxMjYsImV4cCI6MjA3MzcwMzEyNn0.QaMJlyqhZcPorbFUplmZAynz3o21OxDfq_exf2wUrTs';

//   Map<String, String> get _headers => {
//     'apikey': _apiKey,
//     'Authorization': 'Bearer $_apiKey',
//     'Content-Type': 'application/json',
//     'Prefer': 'return=representation',
//   };

//   Future<List<Task>> getTasks() async {
//     final response = await http.get(Uri.parse('$_baseUrl?select=*'), headers: _headers);
//     if (response.statusCode == 200) {
//       List data = json.decode(response.body);
//       return data.map((e) => Task.fromJson(e)).toList();
//     }
//     throw Exception('Gagal memuat tugas');
//   }

//   Future<void> addTask(Task task) async {
//     final response = await http.post(
//       Uri.parse(_baseUrl),
//       headers: _headers,
//       body: json.encode(task.toJson()),
//     );
//     if (response.statusCode != 201) throw Exception('Gagal menambah tugas');
//   }

//   Future<void> updateTask(int id, Map<String, dynamic> data) async {
//     final response = await http.patch(
//       Uri.parse('$_baseUrl?id=eq.$id'),
//       headers: _headers,
//       body: json.encode(data),
//     );
//     if (response.statusCode != 200 && response.statusCode != 204) {
//       throw Exception('Gagal update tugas');
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Tambahkan ini untuk debugPrint
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