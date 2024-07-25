import 'package:flutter/material.dart';
import 'package:flutter_chat/models/usuario.dart';
import 'package:flutter_chat/services/auth_service.dart';
import 'package:flutter_chat/services/chat_service.dart';
import 'package:flutter_chat/services/socket_service.dart';
import 'package:flutter_chat/services/usuarios_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuarioService = UsuariosService();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario; //  mejor con getter
    return Scaffold(
      appBar: AppBar(
          title: Text(
            usuario.nombre,
            style: const TextStyle(color: Colors.blueAccent),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.blueAccent,
            ),
          ),
          actions: [
            Container(
              padding: const EdgeInsets.only(right: 20),
              child: (socketService.serverStatus == ServerStatus.onLine)
                  // child: (usuario.online)  TO-DO...este si cambia de color
                  ? const Icon(Icons.face, color: Colors.blueAccent)
                  : const Icon(Icons.face, color: Colors.red),
            ),
          ]),
      body: SmartRefresher(
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        controller: _refreshController,
        child: _listViewUsuarios(),
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioTile(usuarios[i]),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: usuarios.length,
    );
  }

  ListTile _usuarioTile(Usuario usuario) {
    return ListTile(
      leading: const Icon(Icons.face, color: Colors.blueAccent),
      trailing: Icon(
        Icons.circle,
        color: usuario.online ? Colors.green : Colors.red,
        size: 12,
      ),
      title: Text(
        usuario.nombre,
        style: const TextStyle(color: Colors.blueAccent),
      ),
      subtitle: Text(
        usuario.email,
        style: const TextStyle(color: Colors.grey),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsuarios() async {
    usuarios = await usuarioService.getUsuarios();
    setState(() {});

    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
