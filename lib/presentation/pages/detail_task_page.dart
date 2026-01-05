import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/task_controller.dart';
import '../../../models/task.dart';
import '../../../design_system/styles.dart';

class DetailTaskPage extends StatefulWidget {
  final Task task;
  const DetailTaskPage({super.key, required this.task});

  @override
  State<DetailTaskPage> createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  late TextEditingController _noteController;
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.task.note);
    _isDone = widget.task.isDone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Detail Tugas", style: AppTextStyles.section),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: AppColors.text), onPressed: () => Navigator.pop(context)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text("Edit", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Judul Tugas", style: AppTextStyles.caption),
                  Text(widget.task.title, style: AppTextStyles.section.copyWith(fontSize: 18)),
                  const SizedBox(height: 12),
                  
                  Text("Mata Kuliah", style: AppTextStyles.caption),
                  Text(widget.task.course, style: AppTextStyles.body),
                  const SizedBox(height: 12),
                  
                  Text("Deadline", style: AppTextStyles.caption),
                  Text(widget.task.deadline, style: AppTextStyles.body),
                  const SizedBox(height: 12),
                  
                  Text("Status", style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Container(
                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                     decoration: BoxDecoration(
                       color: _isDone ? Colors.green.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: Text(
                       _isDone ? "SELESAI" : widget.task.status,
                       style: TextStyle(
                         color: _isDone ? Colors.green : AppColors.primary, 
                         fontWeight: FontWeight.bold, fontSize: 12
                       ),
                     ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            
        
            const Text("Penyelesaian", style: AppTextStyles.section),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: CheckboxListTile(
                title: const Text("Tugas sudah selesai", style: AppTextStyles.body),
                subtitle: const Text("Centang jika tugas sudah final", style: AppTextStyles.caption),
                value: _isDone,
                activeColor: AppColors.primary,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                onChanged: (val) {
                  setState(() => _isDone = val!);
                },
              ),
            ),
            const SizedBox(height: 24),
            
          
            const Text("Catatan", style: AppTextStyles.section),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Pisahkan Controller, Service...",
                hintStyle: AppTextStyles.caption,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border))),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () async {
            final controller = context.read<TaskController>();
            if (_isDone != widget.task.isDone) {
              await controller.toggleTaskStatus(widget.task.id!, _isDone);
            }
            if (_noteController.text != widget.task.note) {
              await controller.updateTaskNote(widget.task.id!, _noteController.text);
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text("Simpan Perubahan", style: AppTextStyles.button),
        ),
      ),
    );
  }
}