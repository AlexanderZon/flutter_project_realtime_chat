import 'package:http/http.dart' as http;
import 'package:realtime_chat_project/globals/environment.dart';
import 'package:realtime_chat_project/models/user_model.dart';
import 'package:realtime_chat_project/models/usuarios_list_response_model.dart';
import 'package:realtime_chat_project/services/auth_service.dart';

class UsuariosService {
  Future<List<UserModel>> getUsuarios() async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.http(
          '${Environment.host}', '${Environment.apiEndpoint}/usuarios');
      final resp = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'x-token': token!},
      );

      final usuariosResponse = usuariosListResponseFromJson(resp.body);

      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
