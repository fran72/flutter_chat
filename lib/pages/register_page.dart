import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/custom_input.dart';
import 'package:flutter_chat/widgets/elevated_button.dart';
import 'package:flutter_chat/widgets/labels.dart';
import 'package:flutter_chat/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Logo(titulo: 'register'),
                  _Form(),
                  const SizedBox(height: 30),
                  const Labels(
                      ruta: 'login',
                      title: '¿Ya tienes cuenta?',
                      subtitle: 'Accessssa ahora'),
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  // const _Form({super.key});

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          CustomInput(
            icon: const Icon(Icons.perm_identity),
            placeholder: 'Nombre',
            textController: nameCtrl,
            keyboardtype: TextInputType.name,
          ),
          CustomInput(
            icon: const Icon(Icons.mail),
            placeholder: 'Email',
            textController: emailCtrl,
            keyboardtype: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: const Icon(Icons.key),
            placeholder: 'Password',
            textController: passCtrl,
            keyboardtype: TextInputType.visiblePassword,
          ),
          CustomElevatedButton(
              emailCtrl: emailCtrl, passCtrl: passCtrl, text: 'Ingrese'),
        ],
      ),
    );
  }
}
