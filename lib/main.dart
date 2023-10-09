import 'package:blog_explorer/views/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../models/blog_adapter.dart';
import '../models/blog_model.dart';
import '../providers/blog_provider.dart';
import '../providers/network_provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Blog>(BlogAdapter());
  await Hive.openBox<Blog>('blogs');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => BlogProvider()),
      ChangeNotifierProvider(create: (context) => NetworkProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
