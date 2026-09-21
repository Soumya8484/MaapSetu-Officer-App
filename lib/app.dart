import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

class LegalMetrologyApp extends StatelessWidget {
  const LegalMetrologyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Legal Metrology',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}