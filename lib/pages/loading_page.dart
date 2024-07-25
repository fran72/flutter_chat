import 'package:flutter/material.dart';
import 'package:flutter_chat/services/auth_service.dart';
import 'package:flutter_chat/services/socket_service.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) => const Center(
          child: Text('Espere...'),
        ),
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    final autenticado = await authService.isLoggedIn();
    if (autenticado) {
      socketService.connect();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, 'usuarios');
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
