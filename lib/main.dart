import 'package:flutter/material.dart';
import 'TelaLogin.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  Map<String, dynamic> dadosRegistro = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TelaLogin(dadosRegistro),
      theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.lightGreen[100]),
    );
  }
}
