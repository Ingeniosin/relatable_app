import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/form_utils.dart';
import '../../utils/toast_utils.dart';

class CreateChatScreen extends StatefulWidget {
  static const String name = 'create-chat';

  const CreateChatScreen({Key? key}) : super(key: key);

  @override
  State<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  final Map<String, String? Function(String?)> validators = {
    'name': FormUtils.getValidator([
      Validator("El nombre tiene que se mayor a 6 caracteres.", (value) => value!.trim().length > 6),
      Validator("En nombre solo puede contener letras y espacios.",
          (value) => value!.trim().contains(RegExp(r'^[a-zA-Z ]+$'))),
    ]),
    'type': FormUtils.getValidator([
      Validator("El tipo es requerido.", (value) => value != null && value.trim().isNotEmpty),
    ]),
    'amount': FormUtils.getValidator([
      Validator("El monto tiene que se mayor a 0.",
          (value) => value != null && value.trim().isNotEmpty && value != 0.toString() && double.parse(value) > 0),
    ]),
  };

  bool get isValid => formKey.currentState!.validate();

  String name = '';
  String type = '';
  int amount = 0;

  void submit() {
    if (!isValid) {
      return;
    }

    chats.add({
      'name': name,
      'type': type,
      'amount': amount,
    }).then((value) {
      Navigator.of(context).pop();
      ToastUtils.success('Chat creado correctamente');
    }).catchError((error) {
      ToastUtils.error(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                ),
                validator: validators['name'],
                onChanged: (value) => setState(() => name = value),
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tipo',
                ),
                validator: validators['type'],
                onChanged: (value) => setState(() => type = value ?? ''),
                items: const [
                  DropdownMenuItem(
                    value: 'public',
                    child: Text('Publico'),
                  ),
                  DropdownMenuItem(
                    value: 'private',
                    child: Text('Privado'),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Monto',
                ),
                validator: validators['amount'],
                onChanged: (value) => setState(() => amount = int.parse(value)),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: submit,
                child: const Text('Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
