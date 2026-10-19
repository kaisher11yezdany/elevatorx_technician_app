import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/job_provider.dart';
import 'providers/service_report_provider.dart';

void main() {
  final apiService = ApiService();

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => apiService),
        ChangeNotifierProvider(create: (_) => AuthProvider(apiService)),
        ChangeNotifierProvider(create: (_) => JobProvider(apiService)),
        ChangeNotifierProvider(create: (_) => ServiceReportProvider(apiService)),
      ],
      child: const MyApp(),
    ),
  );
}
