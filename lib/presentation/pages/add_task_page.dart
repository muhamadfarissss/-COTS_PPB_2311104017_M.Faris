import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../controllers/task_controller.dart';
import '../../../models/task.dart';
import '../../../design_system/styles.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedCourse;
  DateTime? _selectedDate;

  final List<String> courses = [
    'Pemrograman Lanjut',
    'Rekayasa Perangkat Lunak',
    'Metodologi Penelitian',
    'UI/UX Design'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Tambah Tugas", style: AppTextStyles.section),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Judul Tugas"),
                    TextFormField(
                      controller: _titleController,
                      decoration: _inputDecoration("Masukkan judul tugas").copyWith(
                        errorStyle: TextStyle(color: AppColors.danger),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.danger)),
                      ),
                      validator: (val) => val!.isEmpty ? "Judul tugas wajib diisi" : null,
                    ),
                    SizedBox(height: 16),
            
                    _buildLabel("Mata Kuliah"),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration("Pilih mata kuliah"),
                      items: courses.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setState(() => _selectedCourse = val),
                      validator: (val) => val == null ? "Mata kuliah wajib dipilih" : null,
                    ),
                    SizedBox(height: 16),
            
                    _buildLabel("Deadline"),
                    InkWell(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) setState(() => _selectedDate = picked);
                      },
                      child: InputDecorator(
                        decoration: _inputDecoration("Pilih tanggal").copyWith(
                          suffixIcon: Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.muted),
                        ),
                        child: Text(
                          _selectedDate == null 
                            ? "Pilih tanggal" 
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                          style: _selectedDate == null 
                            ? AppTextStyles.caption.copyWith(fontSize: 14) 
                            : AppTextStyles.body,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
            
                    _buildLabel("Catatan"),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 4,
                      decoration: _inputDecoration("Catatan tambahan (opsional)"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom Buttons
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border))),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(0, 48),
                      side: BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text("Batal", style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: Size(0, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _selectedCourse != null && _selectedDate != null) {
                        final newTask = Task(
                          title: _titleController.text,
                          course: _selectedCourse!,
                          deadline: DateFormat('yyyy-MM-dd').format(_selectedDate!),
                          status: "BERJALAN",
                          note: _noteController.text,
                          isDone: false,
                        );
                        context.read<TaskController>().addTask(newTask);
                        Navigator.pop(context);
                      } else if (_selectedDate == null) {
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deadline harus diisi")));
                      }
                    },
                    child: Text("Simpan", style: AppTextStyles.button),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: AppTextStyles.section.copyWith(fontSize: 14)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.caption.copyWith(fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary)),
    );
  }
}