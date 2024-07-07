import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final Icon icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardtype;
  const CustomInput(
      {super.key,
      required this.icon,
      required this.placeholder,
      required this.textController,
      required this.keyboardtype});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(0, 2),
                blurRadius: 5,
              ),
            ]),
        child: TextField(
          controller: textController,
          autocorrect: false,
          keyboardType: keyboardtype,
          decoration: InputDecoration(
            prefixIcon: icon,
            prefixIconColor: Colors.blue,
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: placeholder,
          ),
        ));
  }
}
