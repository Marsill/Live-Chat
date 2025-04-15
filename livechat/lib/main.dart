import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:livechat/auth/auth_gate.dart';
import 'package:livechat/auth/firebase_auth/firebase_auth.dart';
import 'package:livechat/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  // Initialize Firebase
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBQk4fPxiYJd1rgC6s3WghzZYp4B3JeiVk",
        appId: "1:112111079275:web:a17286e3d375a7641b862e",
        messagingSenderId: "112111079275",
        projectId: "livechat-c661b",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Run the app with Provider
  runApp(
    ChangeNotifierProvider(
      create: (context) => FirebaseAuthService(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        child: AuthGate(),
      ),
    );
  }
}
