import 'package:flutter_chat/global/environment.dart';
import 'package:flutter_chat/models/usuario.dart';
import 'package:flutter_chat/models/usuarios_response.dart';
import 'package:flutter_chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    var token = await AuthService.getToken() ?? '';
    try {
      final resp = await http.get(
        Uri.parse('${Environment.apiUrl}/usuarios'),
        headers: {
          'Content-type': 'application/json',
          'x-token': token,
        },
      );

      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
