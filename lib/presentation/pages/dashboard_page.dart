import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/task_controller.dart';
import '../../../design_system/styles.dart';
import '../../../models/task.dart';
import 'task_list_page.dart';
import 'add_task_page.dart';
import 'detail_task_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TaskController>().fetchTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Beranda", style: AppTextStyles.title),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Consumer<TaskController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          // Ambil 3 tugas teratas untuk dashboard
          final displayedTasks = controller.tasks.take(3).toList();

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Tugas Besar
                      Text("Tugas Besar", style: AppTextStyles.title),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          _buildSummaryCard(
                            "Total Tugas",
                            "${controller.totalTasks}",
                          ),
                          SizedBox(width: 16),
                          _buildSummaryCard(
                            "Selesai",
                            "${controller.completedTasks}",
                          ),
                        ],
                      ),
                      SizedBox(height: 24),

                      // Section Tugas Terdekat
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tugas Terdekat", style: AppTextStyles.section),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => TaskListPage()),
                            ),
                            child: Text(
                              "Daftar Tugas",
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // List Tugas Custom
                      ...displayedTasks
                          .map((task) => _buildTaskCard(context, task))
                          .toList(),
                    ],
                  ),
                ),
              ),

              // Tombol Tambah Tugas di Bawah (Fixed)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddTaskPage()),
                  ),
                  child: Text("Tambah Tugas", style: AppTextStyles.button),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
          ), // Border tipis sesuai gambar
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.caption.copyWith(fontSize: 14),
            ), // Font size caption agak besar dikit
            SizedBox(height: 4),
            Text(
              count,
              style: AppTextStyles.title.copyWith(fontSize: 32),
            ), // Angka besar
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    Color statusColor = task.isDone ? Colors.green : AppColors.primary;
    Color statusBg = task.isDone
        ? Colors.green.withOpacity(0.1)
        : AppColors.primary.withOpacity(0.1);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailTaskPage(task: task)),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: AppTextStyles.section,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        task.course,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: AppColors.muted),
                SizedBox(width: 4),
                Text(
                  "Deadline: ${task.deadline}",
                  style: AppTextStyles.caption.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
