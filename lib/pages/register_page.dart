import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat_project/helpers/mostrar_alerta.dart';
import 'package:realtime_chat_project/services/auth_service.dart';
import 'package:realtime_chat_project/widgets/blue_button_widget.dart';
import 'package:realtime_chat_project/widgets/custom_input_widget.dart';
import 'package:realtime_chat_project/widgets/labels_widget.dart';
import 'package:realtime_chat_project/widgets/logo_widget.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LogoWidget(
                  title: 'Registrar',
                ),
                _Form(),
                LabelsWidget(
                  title: 'Ya tienes cuenta?',
                  subtitle: 'Has login ahora!',
                  route: 'login',
                ),
                Text(
                  'Términos y Condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({super.key});

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInputWidget(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.emailAddress,
            textController: nameController,
          ),
          CustomInputWidget(
            icon: Icons.mail_outline,
            placeholder: 'E-mail',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),
          CustomInputWidget(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            keyboardType: TextInputType.text,
            isPassword: true,
            textController: passwordController,
          ),
          BlueButtonWidget(
            text: 'Crear cuenta',
            onPressed: authService.isAuthenticating
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final registerOk = await authService.register(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      nameController.text.trim(),
                    );
                    if (registerOk) {
                      // TODO: Conectar a nuestro socket server
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      mostrarAlerta(context, 'Error en el Registro',
                          authService.errorMessage);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
