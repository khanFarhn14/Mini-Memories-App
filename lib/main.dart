import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mini_memories/home.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp
  (
    const MaterialApp
    (
      debugShowCheckedModeBanner: false,
      home: HomePage()
    )
  );
}