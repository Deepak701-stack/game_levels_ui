import 'package:flutter/material.dart';
import 'custom_painter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
    home: TreeViewPage(),
  );
}

class TreeViewPage extends StatefulWidget {
  const TreeViewPage({Key? key}) : super(key: key);

  @override
  State<TreeViewPage> createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
          body: CustomPainterClass()
      )
    );
  }
}