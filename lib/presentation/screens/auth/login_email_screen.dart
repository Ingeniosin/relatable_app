import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:relatable_app/presentation/screens/screens.dart';
import 'package:relatable_app/presentation/widgets/loading_widget.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../providers/auth_provider.dart';
import '../../utils/form_utils.dart';
import '../../utils/toast_utils.dart';
import '../../widgets/logo_widget.dart';

class LoginEmailScreen extends StatefulWidget {
  static const name = 'login-email-screen';

  const LoginEmailScreen({super.key});

  @override
  State<LoginEmailScreen> createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Map<String, String? Function(String?)> validators = {
    'email': FormUtils.getValidator([
      Validator("El correo electronico no contiene el formato necesario.",
          (value) => value?.trim().contains(RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'))),
    ]),
  };

  bool get isValid => formKey.currentState!.validate();

  String email = '';

  void submit(AuthProvider authProvider) {
    if (!isValid) {
      return;
    }

    authProvider.checkEmail(email).then((emailExists) {
      if (!emailExists) {
        ToastUtils.error("No se encontro el correo electronico, ¿Quieres registrarte?");
        return;
      }

      context.pushNamed(LoginPasswordScreen.name, extra: email);
    }).catchError((error) {
      ToastUtils.error(error.toString());
    });
  }

  void register() {
    context.pushNamed(RegisterScreen.name);
  }

  void signInWithGoogle(AuthProvider authProvider) {
    authProvider.signInWithGoogle().then((_) {
      context.goNamed(HomeScreen.name);
    }).catchError((error) {
      ToastUtils.error(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isLoaded) {
      return const Scaffold(body: LoadingWidget());
    }

    if (authProvider.isSignIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed(HomeScreen.name);
      });
    }

    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: height / 4),
            const LogoWidget(),
            const Text(
              'Primero lo primero, ¿Cuál es tu correo electronico?',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Form(
              key: formKey,
              child: TextFormField(
                validator: validators['email'],
                onChanged: (value) => email = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo electronico',
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            SignInButton(
              Buttons.google,
              text: "Iniciar sesión con Google",
              onPressed: () => signInWithGoogle(authProvider),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => submit(authProvider),
              child: const Text('Continuar'),
            ),
            TextButton(
              onPressed: register,
              child: const Text('No tengo usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
