import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './controllers/task_controller.dart';
import 'presentation/pages/dashboard_page.dart';
import './design_system/styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskController()),
      ],
      child: MaterialApp(
        title: 'COTS App',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
        ),
        home: DashboardPage(),
      ),
    );
  }
}