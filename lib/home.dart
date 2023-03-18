import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: Center
      (
        child: Container
        (
          width: 150,
          height: 150,
          color: Colors.black,
          child: const Text("Camera")
        )
      )
    );
  }
}