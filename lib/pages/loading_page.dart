import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat_project/services/auth_service.dart';

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
    final isAuthenticated = await authService.isLoggedIn();

    if (isAuthenticated) {
      // TODO: conectar al socket server
      Navigator.pushReplacementNamed(context, 'users');
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
