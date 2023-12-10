import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat_project/services/auth_service.dart';
import 'package:realtime_chat_project/services/socket_service.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: ((context, snapshot) {
          return Center(
            child: Text('Cargando'),
          );
        }),
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final isAuthenticated = await authService.isLoggedIn();

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, 'users');
      socketService.connect();
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
