import 'package:MediFlow/firebase_options.dart';
import 'package:MediFlow/screens/home/home_screen.dart';
import 'package:MediFlow/screens/other/on_boarding_screen.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseFirestore.instance.settings =Settings(
  //   persistenceEnabled: true
  // );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Gemini.init(apiKey:'AIzaSyCVceLhU5DiT9Tq-A4JBRiOFcUaYFANRcY');
  runApp( MyApp(loginedUser: prefs.getString('userId') !=null,));
}

class MyApp extends StatelessWidget {
  final bool loginedUser;
  const MyApp({super.key, required this.loginedUser});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Poppins-Regular'
      ),
      home: loginedUser?HomeScreen():OnBoardingScreen(),
    );
  }
}
