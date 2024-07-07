import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final String text;

  const CustomElevatedButton(
      {super.key,
      required this.emailCtrl,
      required this.passCtrl,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            )),
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 60))),
        onPressed: () {
          debugPrint('emailCtrl.text');
          debugPrint(emailCtrl.text);
          debugPrint(passCtrl.text);
        },
        child: Text(text, style: const TextStyle(fontSize: 16)));
  }
}
