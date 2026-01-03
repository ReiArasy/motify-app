import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import 'register_page.dart';

// LoginPage
// ------------------------------------------------------------
// Halaman login user menggunakan Supabase Auth.
//
// Flow:
// 1. User isi email + password
// 2. Tekan tombol Login
// 3. AuthController.login dipanggil
// 4. Jika sukses → masuk ke aplikasi
// 5. Jika gagal → tampilkan error
class LoginPage extends StatefulWidget {
  final AuthController authController;

  const LoginPage({Key? key, required this.authController}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller input
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State UI
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    // dispose untuk mencegah memory leak
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handle Login
  Future<void> _handleLogin() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      await widget.authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // JANGAN NAVIGATE
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // JUDUL
            Text(
              'Hi!, Selamat Datang👋',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'Masuk untuk melihat dan menambahkan motivasi',
              style: TextStyle(color: Colors.grey[700]),
            ),

            const SizedBox(height: 24),

            // INPUT EMAIL
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // INPUT PASSWORD
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ERROR MESSAGE
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 12),

            // BUTTON LOGIN
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Login'),
            ),

            const SizedBox(height: 12),

            // LINK KE REGISTER
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RegisterPage(authController: widget.authController),
                  ),
                );
              },
              child: const Text('Belum punya akun? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
