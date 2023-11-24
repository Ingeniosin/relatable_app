import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:relatable_app/presentation/utils/toast_utils.dart';

import '../../providers/auth_provider.dart';
import '../../utils/form_utils.dart';
import '../../widgets/logo_widget.dart';

class LoginPasswordScreen extends StatefulWidget {
  static const name = 'login-password-screen';

  const LoginPasswordScreen({super.key});

  @override
  State<LoginPasswordScreen> createState() => _LoginPasswordScreenState();
}

class _LoginPasswordScreenState extends State<LoginPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Map<String, String? Function(String?)> validators = {
    'password': FormUtils.getValidator([
      Validator("La contraseña debe tener al menos 6 caracteres.",
          (value) => value != null ? value.trim().length >= 6 : false),
    ]),
  };

  bool showPassword = false;

  String password = '';

  bool get isValid => formKey.currentState!.validate();

  void signIn(AuthProvider authProvider, String email) async {
    if (!isValid) {
      return;
    }

    ToastUtils.info('Iniciando sesion');
    await authProvider.signInWithEmailAndPassword(email, password).then((value) {
      ToastUtils.success('Sesion iniciada');
      context.go('/home');
    }).catchError((error) {
      ToastUtils.error(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final String email = GoRouterState.of(context).extra! as String;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: height / 4),
              const LogoWidget(),
              const Text(
                'Ahora, tu contraseña',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Form(
                key: formKey,
                child: TextFormField(
                  onChanged: (value) => password = value,
                  obscureText: !showPassword,
                  validator: validators['password'],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                          ToastUtils.info(showPassword ? 'Mostrando contraseña' : 'Ocultando contraseña');
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => signIn(authProvider, email),
                child: const Text('Iniciar sesión'),
              ),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Este no es mi usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
