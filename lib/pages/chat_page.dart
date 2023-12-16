import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat_project/models/mensaje_model.dart';
import 'package:realtime_chat_project/services/auth_service.dart';
import 'package:realtime_chat_project/services/chat_service.dart';
import 'package:realtime_chat_project/services/socket_service.dart';
import 'package:realtime_chat_project/widgets/chat_message_widget.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessageWidget> _messages = [];
  bool _isWriting = false;

  late AuthService authService;
  late ChatService chatService;
  late SocketService socketService;

  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket
        .on('mensaje-personal', (data) => _escucharMensaje(data));

    _cargarHistorial(chatService.usuarioPara.uid);

    super.initState();
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessageWidget message = ChatMessageWidget(
      text: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      ),
    );

    setState(() {
      _messages.insert(0, message);
      message.animationController.forward();
    });
  }

  void _cargarHistorial(String usuarioID) async {
    print('Cargar Historial');
    List<Mensaje> chat = await chatService.getChat(usuarioID);

    final history = chat.map(
      (m) => ChatMessageWidget(
        text: m.mensaje,
        uid: m.de,
        animationController:
            AnimationController(vsync: this, duration: Duration.zero)
              ..forward(), // Se utiliza para activar la animación
      ),
    );

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final usuarioPara = chatService.usuarioPara;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                '${usuarioPara.nombre.substring(0, 2)}',
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(
              height: 3,
            ),
            Text('${usuarioPara.nombre}',
                style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, index) => _messages[index],
                itemCount: _messages.length,
                reverse: true,
              ),
            ),
            Divider(height: 1),
            // TODO: Caja de texto
            Container(
              height: 100,
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _messageController,
                onSubmitted: _handleSubmit,
                onChanged: (value) {
                  setState(() {
                    if (value.trim().length > 0) {
                      _isWriting = true;
                    } else {
                      _isWriting = false;
                    }
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Enviar Mensaje'),
                focusNode: _focusNode,
              ),
            ),
            // Boton de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _isWriting
                          ? () => _handleSubmit(_messageController.text.trim())
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(
                          color: Colors.blue[400],
                        ),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed: _isWriting
                              ? () =>
                                  _handleSubmit(_messageController.text.trim())
                              : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.length == 0) {
      _messageController.clear();
      _focusNode.requestFocus();
      return;
    }
    final ChatMessageWidget newMessage = ChatMessageWidget(
      text: text,
      uid: authService.usuario.uid,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });
    socketService.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': text
    });
    _messageController.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (ChatMessageWidget message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
