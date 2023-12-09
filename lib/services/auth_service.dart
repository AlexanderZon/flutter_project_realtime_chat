import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat_project/globals/environment.dart';
import 'package:realtime_chat_project/models/auth_login_response_model.dart';
import 'package:realtime_chat_project/models/auth_register_exception_response_model.dart';
import 'package:realtime_chat_project/models/auth_register_success_response_model.dart';
import 'package:realtime_chat_project/models/user_model.dart';

class AuthService with ChangeNotifier {
  late UserModel usuario;
  late String errorMessage;
  bool _isAuthenticating = false;
  final _storage = new FlutterSecureStorage();

  bool get isAuthenticating => _isAuthenticating;
  set isAuthenticating(bool value) {
    _isAuthenticating = value;
    notifyListeners();
  }

  // Getters del token
  static Future<bool> hasToken() async {
    final _storage = new FlutterSecureStorage();
    String? token = await _storage.read(key: 'token');
    return token is String;
  }

  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    String? token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    isAuthenticating = true;
    final data = {
      'email': email,
      'password': password,
    };

    final resp = await http.post(
        Uri.http(Environment.host, '${Environment.apiEndpoint}/login'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});

    print(resp.body);
    isAuthenticating = false;
    if (resp.statusCode == 200) {
      final authLoginResponse = authLoginResponseModelFromJson(resp.body);
      usuario = authLoginResponse.usuario;

      // Guardar token en algun lugar seguro
      _guardarToken(authLoginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    isAuthenticating = true;
    final data = {
      'email': email,
      'password': password,
      'nombre': name,
    };

    final resp = await http.post(
        Uri.http(Environment.host, '${Environment.apiEndpoint}/login/new'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});

    print(resp.body);
    isAuthenticating = false;
    if (resp.statusCode == 200) {
      final authRegisterSuccessResponse =
          authRegisterSuccessResponseModelFromJson(resp.body);
      usuario = authRegisterSuccessResponse.usuario;

      // Guardar token en algun lugar seguro
      _guardarToken(authRegisterSuccessResponse.token);
      return true;
    } else {
      final authRegisterExceptionResponse =
          authRegisterExceptionResponseModelFromJson(resp.body);
      if (authRegisterExceptionResponse.errors != null) {
        errorMessage = authRegisterExceptionResponse.errors!.getErrorsMessage();
      } else if (authRegisterExceptionResponse.msg != null) {
        errorMessage = authRegisterExceptionResponse.msg!;
      } else {
        errorMessage = 'Hubo un Error desconocido.';
      }
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    print(token);

    if (token == null) return false;

    final resp = await http.get(
        Uri.http(Environment.host, '${Environment.apiEndpoint}/login/renew'),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    isAuthenticating = false;
    if (resp.statusCode == 200) {
      final authLoginResponse = authLoginResponseModelFromJson(resp.body);
      usuario = authLoginResponse.usuario;

      // Guardar token en algun lugar seguro
      _guardarToken(authLoginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
