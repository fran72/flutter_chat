import 'package:flutter/material.dart';
import 'package:flutter_chat/helpers/mostrar_alerta.dart';
import 'package:flutter_chat/services/auth_service.dart';
import 'package:flutter_chat/services/socket_service.dart';
import 'package:provider/provider.dart';

class RegisterCustomElevatedButton extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final String text;

  const RegisterCustomElevatedButton(
      {super.key,
      required this.nameCtrl,
      required this.emailCtrl,
      required this.passCtrl,
      required this.text});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            )),
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 60))),
        onPressed: authService.autenticando
            ? null
            : () async {
                // FocusScope.of(context).unfocus();
                final registerOK = await authService.register(
                  nameCtrl.text.trim(),
                  emailCtrl.text.trim(),
                  passCtrl.text.trim(),
                );
                if (registerOK) {
                  socketService.connect();

                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, 'usuarios');
                } else {
                  // ignore: use_build_context_synchronously
                  mostrarAlerta(context, 'registro incorrecto', 'fallitooo');
                }
              },
        child: Text(text, style: const TextStyle(fontSize: 16)));
  }
}
