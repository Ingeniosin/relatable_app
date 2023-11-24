import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:relatable_app/presentation/screens/auth/login_email_screen.dart';
import 'package:relatable_app/presentation/screens/chat/create_chat.dart';
import 'package:relatable_app/presentation/utils/toast_utils.dart';
import 'package:relatable_app/presentation/widgets/loading_widget.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../chat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> chatStream = FirebaseFirestore.instance.collection('chats').snapshots();

  void logout(AuthProvider authProvider, BuildContext context) {
    authProvider.signOut().then((value) {
      ToastUtils.success('Sesion cerrada');
      context.goNamed(LoginEmailScreen.name);
    }).catchError((error) {
      ToastUtils.error(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatable Community'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(CreateChatScreen.name);
        },
        child: const Icon(Icons.add),
      ),
      drawer: SidebarX(
        controller: SidebarXController(
          selectedIndex: 0,
          extended: true,
        ),
        footerItems: [
          SidebarXItem(
            icon: Icons.logout,
            label: 'Cerrar sesion',
            onTap: () => logout(authProvider, context),
          ),
        ],
        items: const [
          SidebarXItem(icon: Icons.home, label: 'Home'),
          SidebarXItem(icon: Icons.search, label: 'Search'),
          SidebarXItem(icon: Icons.settings, label: 'Settings'),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DataTable(
                    columns: const [
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Tipo')),
                      DataColumn(label: Text('Cantidad')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                      var data = Chat.fromMap(document.data() as Map<String, dynamic>, document.id);
                      return DataRow(
                        cells: [
                          DataCell(Text(data.name)),
                          DataCell(Text(data.type)),
                          DataCell(Text("1/${data.amount}")),
                          DataCell(
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.pushNamed(ChatScreen.name, extra: data);
                                },
                                child: const Text('Entrar'),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList()),
              ],
            ),
          );
        },
      ),
    );
  }
}
