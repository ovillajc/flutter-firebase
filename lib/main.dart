import 'package:flutter/material.dart';

// Importaciones de Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/pages/upload_page.dart';
import 'firebase_options.dart';

import 'package:flutter_firebase/pages/home_page.dart';
import 'package:flutter_firebase/pages/add_name_page.dart';
import 'package:flutter_firebase/pages/edit_name_page.dart';

void main() async {
  // Inicializar el servidor a firebase
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
      title: 'Material App',
      initialRoute: '/upload',
      routes: {
        '/': (context) => const Home(),
        '/add': (context) => const AddNamePage(),
        '/edit': (context) => const EditNamePage(),
        '/upload': (context) => const UploadPage(),
      },
    );
  }
}
