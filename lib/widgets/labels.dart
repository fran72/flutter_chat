import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String title;
  final String subtitle;

  const Labels(
      {super.key,
      required this.ruta,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(color: Colors.black26, fontSize: 12)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, ruta);
            },
            child: Text(subtitle,
                style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 10),
          const Text('Terminos y condiciones de uso',
              style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 12,
                  fontWeight: FontWeight.w300)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
