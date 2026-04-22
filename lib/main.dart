import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ SAFE INITIALIZATION (recommended)
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      themeMode =
          themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Talent Showcase',

      themeMode: themeMode,

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue, // 🔥 changed to match your UI
        scaffoldBackgroundColor: Colors.blue.shade50,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),

      home: LoginScreen(),
    );
  }
}