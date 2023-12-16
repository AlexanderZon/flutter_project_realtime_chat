import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat_project/globals/environment.dart';
import 'package:realtime_chat_project/models/mensaje_model.dart';
import 'package:realtime_chat_project/models/mensajes_list_response.dart';
import 'package:realtime_chat_project/models/user_model.dart';
import 'package:realtime_chat_project/services/auth_service.dart';

class ChatService with ChangeNotifier {
  late UserModel usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioID) async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.http('${Environment.host}',
          '${Environment.apiEndpoint}/mensajes/${usuarioID}');
      final headers = {'Content-Type': 'application/json', 'x-token': token!};
      final resp = await http.get(url, headers: headers);

      if (resp.statusCode == 200) {
        final mensajesResponse = mensajesListResponseFromJson(resp.body);
        return mensajesResponse.mensajes;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
