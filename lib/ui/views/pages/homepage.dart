import 'package:flutter/material.dart';
import 'package:userapp/ui/widgets/customtext.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: customText(text: "asd", fontsize: 12, color: Colors.black)),
      body: const Center(),
    );
  }
}