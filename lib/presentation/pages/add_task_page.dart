import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../controllers/task_controller.dart';
import '../../../models/task.dart';
import '../../../design_system/styles.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
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
    'UI/UX Design',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Tambah Tugas",
          style: AppTextStyles.section.copyWith(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Judul Tugas"),
                    TextFormField(
                      controller: _titleController,
                      decoration: _inputDecoration("Masukkan judul tugas")
                          .copyWith(
                            errorStyle: const TextStyle(
                              color: AppColors.danger,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.danger,
                              ),
                            ),
                          ),
                      validator: (val) =>
                          val!.isEmpty ? "Judul tugas wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),

                    _buildLabel("Mata Kuliah"),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration("Pilih mata kuliah"),
                      items: courses
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _selectedCourse = val),
                      validator: (val) =>
                          val == null ? "Mata kuliah wajib dipilih" : null,
                    ),
                    const SizedBox(height: 16),

                    _buildLabel("Deadline"),
                    InkWell(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          // Diubah ke 2020 agar bisa pilih tanggal lampau untuk tes "TERLAMBAT"
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null)
                          setState(() => _selectedDate = picked);
                      },
                      child: InputDecorator(
                        decoration: _inputDecoration("Pilih tanggal").copyWith(
                          suffixIcon: const Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: AppColors.muted,
                          ),
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
                    const SizedBox(height: 16),

                    _buildLabel("Catatan"),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 4,
                      decoration: _inputDecoration(
                        "Catatan tambahan (opsional)",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Batal",
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _selectedCourse != null &&
                          _selectedDate != null) {
                        // --- LOGIKA PENENTUAN STATUS ---
                        // Ambil waktu sekarang (tanpa jam/menit/detik untuk perbandingan tanggal murni)
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        final deadlineDate = DateTime(
                          _selectedDate!.year,
                          _selectedDate!.month,
                          _selectedDate!.day,
                        );

                        // Default status berjalan
                        String currentStatus = "BERJALAN";

                        // Jika deadline lebih kecil (sebelum) hari ini, maka terlambat
                        if (deadlineDate.isBefore(today)) {
                          currentStatus = "TERLAMBAT";
                        }
                        // -------------------------------

                        final newTask = Task(
                          title: _titleController.text,
                          course: _selectedCourse!,
                          deadline: DateFormat(
                            'yyyy-MM-dd',
                          ).format(_selectedDate!),
                          status: currentStatus, // Menggunakan variabel dinamis
                          note: _noteController.text,
                          isDone: false,
                        );
                        context.read<TaskController>().addTask(newTask);
                        Navigator.pop(context);
                      } else if (_selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Deadline harus diisi")),
                        );
                      }
                    },
                    child: Text("Simpan", style: AppTextStyles.button),
                  ),
                ),
              ],
            ),
          ),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}
