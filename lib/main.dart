import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login.dart';
import 'screens/home_screen.dart';
import 'screens/absensi.dart';
import 'screens/nilai.dart';
import 'screens/data_guru_anak.dart';
import 'screens/rekap_absensi.dart';
import 'screens/Admin.dart';
import 'screens/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // Tambahan agar DatePicker bisa jalan dan pakai lokal Indonesia
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'), // Bahasa Indonesia
        Locale('en', 'US'), // English
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        // Jangan taruh AbsensiScreen di sini karena butuh parameter
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments;

        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(
              builder: (context) => HomeScreen(username: args as String),
            );
          case '/admin':
            return MaterialPageRoute(
              builder: (context) => AdminDashboard(username: args as String),
            );  
          case '/absensi':
            return MaterialPageRoute(
              builder: (context) => AbsensiScreen(username: args as String),
            );
          case '/nilai':
            return MaterialPageRoute(
              builder: (context) => NilaiScreen(username: args as String),
            );
          case '/data':
            return MaterialPageRoute(
              builder: (context) => DataScreen(username: args as String),
            );
          case '/rekap':
            return MaterialPageRoute(
              builder: (context) => RekapScreen(username: args as String),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
        }
      },
    );
  }
}
