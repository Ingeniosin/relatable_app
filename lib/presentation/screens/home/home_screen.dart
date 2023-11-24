import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:relatable_app/presentation/screens/auth/login_email_screen.dart';
import 'package:relatable_app/presentation/utils/toast_utils.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home';

  const HomeScreen({super.key});

  /*() {
          authProvider.signOut().then((value) {
            ToastUtils.success('Sesion cerrada');
            context.goNamed(LoginEmailScreen.name);
          }).catchError((error) {
            ToastUtils.error(error.toString());
          });
        }*/

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
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () => logout(authProvider, context),
                child: const Text('Cerrar sesion'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
