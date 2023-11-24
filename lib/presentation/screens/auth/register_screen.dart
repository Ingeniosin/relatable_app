import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:relatable_app/presentation/screens/home/home_screen.dart';

import '../../providers/auth_provider.dart';
import '../../utils/form_utils.dart';
import '../../utils/toast_utils.dart';
import '../../widgets/logo_widget.dart';

class RegisterScreen extends StatefulWidget {
  static const name = 'register-screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Map<String, String? Function(String?)> validators = {
    'name': FormUtils.getValidator([
      Validator("El nombre no puede estar vacio.", (value) => value != null ? value.trim().isNotEmpty : false),
    ]),
    'email': FormUtils.getValidator([
      Validator("El correo electronico no contiene el formato necesario.",
          (value) => value?.trim().contains(RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'))),
    ]),
    'password': FormUtils.getValidator([
      Validator("La contraseña debe tener al menos 6 caracteres.",
          (value) => value != null ? value.trim().length >= 6 : false),
    ]),
  };

  void submit(AuthProvider authProvider) {
    if (!isValid) {
      return;
    }

    ToastUtils.info('Registrando usuario');
    authProvider.signUpWithEmailAndPassword(email, password, name).then((_) {
      context.goNamed(HomeScreen.name);
    });
  }

  bool showPassword = false;

  bool get isValid => formKey.currentState!.validate();

  String name = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
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
                '¡Bienvenido! Registrate con tu correo electronico',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: validators['name'],
                      onChanged: (value) => name = value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre completo',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      validator: validators['email'],
                      onChanged: (value) => email = value.trim().toLowerCase(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Correo electronico',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      obscureText: !showPassword,
                      validator: validators['password'],
                      onChanged: (value) => password = value,
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
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => submit(authProvider),
                child: const Text('Continuar'),
              ),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Ya tengo usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
