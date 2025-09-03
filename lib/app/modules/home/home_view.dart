import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elecktro E-Commerce'),
      ),
      body: const Center(
        child: Text('Welcome to Elecktro E-Commerce!'),
      ),
    );
  }
}
