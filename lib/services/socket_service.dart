import 'package:flutter/material.dart';
import 'package:realtime_chat_project/services/auth_service.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  Function get emit => _socket.emit;

  SocketService() {
    // this._initConfig();
  }

  void connect() async {
    final token = await AuthService.getToken();

    this._socket = IO.io(
        'http://10.0.2.2:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({'token': token})
            .enableAutoConnect()
            .build());

    this._socket.onConnecting((_) {
      print('connecting');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onConnect((_) {
      print('connected');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onReconnect((_) {
      print('reconnected');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      print('disconnected');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // Lo coloco aquí ya que no ejecuta la función onConnect al momento de conectarse al socket
    _serverStatus = ServerStatus.Online;
    notifyListeners();
  }

  void disconnect() async {
    _socket.disconnect();
    notifyListeners();
  }
}
