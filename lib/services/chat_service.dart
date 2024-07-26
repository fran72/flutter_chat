import 'package:flutter/material.dart';
import 'package:flutter_chat/global/environment.dart';
import 'package:flutter_chat/models/mensajes_response.dart';
import 'package:flutter_chat/models/usuario.dart';
import 'package:flutter_chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;

  Future<List<Mensaje>> getChats(String usuarioId) async {
    final resp = await http
        .get(Uri.parse('${Environment.apiUrl}/mensajes/$usuarioId'), headers: {
      'Content-type': 'application/json',
      'x-token': await AuthService.getToken() as String,
    });

    final mensajesResponse = mensajesResponseFromJson(resp.body);
    return mensajesResponse.mensajes;
  }
}
