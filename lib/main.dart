import 'package:flutter/material.dart';
import 'package:sketch_n_seek/features/home/screens/home_screen.dart';
import 'package:sketch_n_seek/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sketch&Seek',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const HomeScreen(),
    );
  }
}



  