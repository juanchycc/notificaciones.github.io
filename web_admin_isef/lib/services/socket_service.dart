import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

const url = 'http://localhost:3000/';
//const url = '192.168.0.21:3000/';

class SocketService with ChangeNotifier {
  List<Map<String, dynamic>> _anuncios = [];

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  Function get emit => _socket.emit;

  List<Map<String, dynamic>> getAnuncios() => _anuncios;

  //TODO: eliminar en la BD
  void eliminarAnuncio(int index, String id) {
    _anuncios.removeAt(index);
    emit("eliminar-anuncio", {'_id': id});
    notifyListeners();
  }

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    _socket = IO.io(url, {
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
      //socket.emit('msg', 'test');
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on('recibir-anuncios', (data) {
      List<dynamic> resp = data;
      _anuncios = [];
      resp.forEach(
        (element) {
          _anuncios.add(element as Map<String, dynamic>);
        },
      );
      print(_anuncios);
      notifyListeners();
    });
  }
}
