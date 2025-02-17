import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/mensajes_response.dart';
import 'package:flutter_chat/services/auth_service.dart';
import 'package:flutter_chat/services/chat_service.dart';
import 'package:flutter_chat/services/socket_service.dart';
import 'package:flutter_chat/widgets/chat_message.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;
  final List<ChatMessage> _messages = [];
  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);
    _cargarHistorial(chatService.usuarioPara.id);
  }

  void _cargarHistorial(String usuarioId) async {
    List<Mensaje> chat = await chatService.getChats(usuarioId);
    final history = chat.map(
      (e) => ChatMessage(
        text: e.mensaje,
        uid: e.de,
        animationController:
            AnimationController(vsync: this, duration: Duration.zero)
              ..forward(),
      ),
    );
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
        text: payload['mensaje'],
        uid: payload['uid'],
        animationController:
            AnimationController(vsync: this, duration: Duration.zero));

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
                backgroundColor: Colors.white,
                maxRadius: 12,
                child: Text(chatService.usuarioPara.nombre.substring(0, 2))),
            const SizedBox(height: 3),
            Text(
              chatService.usuarioPara.nombre,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: SizedBox(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, i) => _messages[i],
                itemCount: _messages.length,
                // reverse: true,
              ),
            ),
            const Divider(
              height: 1,
            ),
            Container(
              color: Colors.white70,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String text) {
                  setState(() {
                    if (text.trim().isNotEmpty) {
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration:
                    const InputDecoration.collapsed(hintText: 'hintText'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      onPressed: _estaEscribiendo
                          ? () => _handleSubmit(_textController.text)
                          : null,
                      child: const Text('data'),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: const IconThemeData(color: Colors.blue),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: _estaEscribiendo
                              ? () => _handleSubmit(_textController.text)
                              : null,
                          icon: const Icon(Icons.send),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;

    final newMessage = ChatMessage(
      text: text,
      uid: authService.usuario.id,
      animationController: AnimationController(
          vsync: this, duration: const Duration(microseconds: 400)),
    );
    _messages.insert(_messages.length, newMessage);
    newMessage.animationController.forward();
    _focusNode.requestFocus();
    _textController.clear();

    socketService.socket.emit('mensaje-personal', {
      'de': authService.usuario.id,
      'para': chatService.usuarioPara.id,
      'mensaje': text,
    });

    setState(() {
      _estaEscribiendo = false;
    });
  }

  @override
  void dispose() {
    socketService.socket.off('mensaje-personal', _escucharMensaje);

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
