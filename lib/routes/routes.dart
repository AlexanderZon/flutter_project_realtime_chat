import 'package:flutter/material.dart';
import 'package:realtime_chat_project/pages/chat_page.dart';
import 'package:realtime_chat_project/pages/loading_page.dart';
import 'package:realtime_chat_project/pages/login_page.dart';
import 'package:realtime_chat_project/pages/register_page.dart';
import 'package:realtime_chat_project/pages/users_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users': (_) => UsersPage(),
  'chat': (_) => ChatPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),
};
