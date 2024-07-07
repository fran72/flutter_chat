import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String titulo;
  const Logo({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          const Image(image: AssetImage('assets/tag-logo.png'), height: 80),
          const SizedBox(height: 20),
          Text(titulo, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
