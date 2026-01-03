import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controller/auth_controller.dart';
import '../controller/quote_controller.dart';

import '../pages/login_page.dart';
import '../main.dart'; 

// AuthGate
// ------------------------------------------------------------
// Menentukan halaman awal berdasarkan status login Supabase
//
// - BELUM login ke LoginPage
// - SUDAH login ke HomeShell
class AuthGate extends StatelessWidget {
  final AuthController authController;

  const AuthGate({
    Key? key,
    required this.authController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;

        // BELUM LOGIN
        if (session == null) {
          return LoginPage(authController: authController);
        }

        // SUDAH LOGIN
        final quoteController = QuoteController();

        return HomeShell(
          controller: quoteController,
          authController: authController, 
        );
      },
    );
  }
}
