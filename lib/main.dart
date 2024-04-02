import 'package:flutter/material.dart';
import 'package:supabase_demo/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
      url: 'https://hglkaymoyxeamzowhqyl.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhnbGtheW1veXhlYW16b3docXlsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE5NTUwNzMsImV4cCI6MjAyNzUzMTA3M30.QpD_dcTfcxCPFeJcucJpN-Yu2PA9tfPGvUqfXLjlUhs');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
