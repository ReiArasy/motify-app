import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';

// RegisterPage
// ------------------------------------------------------------
// Halaman untuk mendaftarkan user baru.
//
// Flow:
// 1. User isi email, username, password
// 2. Tekan tombol Register
// 3. AuthController.register dipanggil
// 4. Jika sukses → kembali (nanti diarahkan ke Home/Login)
// 5. Jika gagal → tampilkan error
class RegisterPage extends StatefulWidget {
  final AuthController authController;

  const RegisterPage({Key? key, required this.authController})
    : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller input form
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // state ui
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    // supaya tidak memory leak
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handle Register
  // - Validasi sederhana
  // - Panggil AuthController.register
  // - Tangani error
  Future<void> _handleRegister() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      await widget.authController.register(
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      // Jika sukses, tampilkan snackbar pop up
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.pop(context); 
      }
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
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// --------------------------------------------------
            /// JUDUL
            /// --------------------------------------------------
            Text(
              'Buat Akun Baru',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'Daftar untuk mulai menambahkan motivasi',
              style: TextStyle(color: Colors.grey[700]),
            ),

            const SizedBox(height: 24),

            /// --------------------------------------------------
            /// INPUT EMAIL
            /// --------------------------------------------------
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// --------------------------------------------------
            /// INPUT USERNAME
            /// --------------------------------------------------
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// --------------------------------------------------
            /// INPUT PASSWORD
            /// --------------------------------------------------
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// --------------------------------------------------
            /// ERROR MESSAGE
            /// --------------------------------------------------
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 12),

            /// --------------------------------------------------
            /// BUTTON REGISTER
            /// --------------------------------------------------
            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              child: _isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Register'),
            ),

            const SizedBox(height: 12),

            /// --------------------------------------------------
            /// LINK KE LOGIN
            /// --------------------------------------------------
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Sudah punya akun? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
