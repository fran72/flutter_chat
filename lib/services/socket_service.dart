import 'package:flutter/material.dart';
import 'package:flutter_chat/global/environment.dart';

import 'package:socket_io_client/socket_io_client.dart' as socket_io_client;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  onLine,
  offLine,
  connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late socket_io_client.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect() {
    // Dart Client from: https://pub.dev/packages/socket_io_client
    _socket = socket_io_client.io(
      Environment.socketUrl,
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .enableAutoConnect() // disable auto-connection
          .enableForceNew()
          .build(),
    );

    // _socket.connect();

    _socket.onConnect((_) {
      debugPrint('onConnect..................................');

      // _socket.emit('mensajeee', 'Conectado desde flutter');
      _serverStatus = ServerStatus.onLine;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      debugPrint('onDisconnect................................');

      _serverStatus = ServerStatus.offLine;
      notifyListeners();
    });

    _socket.on('nuevo-mensaje', (payload) {
      debugPrint('nuevo-mensajevvvvvvvvvvv');
      notifyListeners();
    });

    // _socket.off('nuevo-mensaje');
  }

  void disconnect() {
    _socket.disconnect();
  }
}
