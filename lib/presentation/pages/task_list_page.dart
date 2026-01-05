import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/task_controller.dart';
import '../../design_system/styles.dart';
import '../../models/task.dart';
import 'detail_task_page.dart';
import 'add_task_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String _filter = "Semua";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Daftar Tugas", style: AppTextStyles.section),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskPage())),
              child: Row(
                children: [
                  Text("Tambah", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                  SizedBox(width: 4),
                  Icon(Icons.add_circle_outline, color: AppColors.primary, size: 20),
                ],
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white, // Bagian header tetap putih
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: "Cari tugas atau mata kuliah...",
                    hintStyle: AppTextStyles.caption.copyWith(fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                    filled: true,
                    fillColor: AppColors.background, // Sedikit abu-abu sesuai gambar
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ["Semua", "Berjalan", "Selesai", "Terlambat"].map((filter) {
                      bool isActive = _filter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isActive,
                          selectedColor: AppColors.primary,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: isActive ? Colors.transparent : AppColors.border),
                          ),
                          labelStyle: TextStyle(
                            color: isActive ? Colors.white : AppColors.text,
                            fontWeight: FontWeight.w500,
                          ),
                          onSelected: (val) => setState(() => _filter = filter),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Task List
          Expanded(
            child: Consumer<TaskController>(
              builder: (context, controller, child) {
                List<Task> filteredTasks = controller.tasks.where((t) {
                  if (_filter == "Semua") return true;
                  if (_filter == "Berjalan") return t.status == "BERJALAN";
                  if (_filter == "Selesai") return t.status == "SELESAI";
                  if (_filter == "Terlambat") return t.status == "TERLAMBAT";
                  return true;
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return _buildListItem(context, task);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Task task) {
    Color dotColor = task.isDone ? Colors.green : (task.status == "TERLAMBAT" ? AppColors.danger : AppColors.primary);
    
    // Parse tanggal untuk format "20 Jan"
    // Asumsi format deadline YYYY-MM-DD
    String dateDisplay = task.deadline; 
    try {
      DateTime dt = DateTime.parse(task.deadline);
      // Manual simple formatting atau gunakan intl jika sudah setup locale
      const months = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"];
      dateDisplay = "${dt.day} ${months[dt.month - 1]}";
    } catch (e) {}

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailTaskPage(task: task))),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Dot Indicator
            Container(
              width: 10, height: 10,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: AppTextStyles.section.copyWith(fontSize: 14)),
                  SizedBox(height: 4),
                  Text(task.course, style: AppTextStyles.caption),
                ],
              ),
            ),
            
            // Date & Chevron
            Row(
              children: [
                Text(dateDisplay, style: AppTextStyles.body.copyWith(color: AppColors.muted)),
                SizedBox(width: 8),
                Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
              ],
            )
          ],
        ),
      ),
    );
  }
}