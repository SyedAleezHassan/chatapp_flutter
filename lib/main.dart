// import 'package:chat_app/main_layout_page/front_layout.dart';
import 'package:chatapp_flutter/chat_page_work/main_chats.dart';
import 'package:chatapp_flutter/register/register_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'register/login_auth.dart';
import 'main_layout_page/front_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure widgets binding is initialized before Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e, stacktrace) {
    print('Firebase initialization failed: $e');
    print('Stacktrace: $stacktrace');
    // Optionally handle error, for example, show an error screen or retry initialization
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationPage(),
    );
  }
}
