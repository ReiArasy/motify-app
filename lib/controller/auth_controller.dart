import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';

// AuthController
// ------------------------------------------------------------
// Controller ini bertugas menangani:
// - Autentikasi user (login, register, logout)
// - Menyimpan state user login
// - Sinkronisasi user auth Supabase => tabel profiles
//
// Controller ini EXTENDS ChangeNotifier agar:
// UI bisa rebuild otomatis saat status login berubah
class AuthController extends ChangeNotifier {
  // Supabase client (singleton dari SupabaseFlutter)
  final SupabaseClient _client = SupabaseClientService.client;

  // Menyimpan user yang sedang login
  User? _currentUser;

  // Getter user (dipakai UI / guard)
  User? get currentUser => _currentUser;

  // Status login user
  bool get isLoggedIn => _currentUser != null;

  // Constructor
  // Saat controller dibuat, langsung cek apakah usersudah login sebelumnya (session tersimpan)
  AuthController() {
    _loadSession();
  }

  // Load session dari Supabase
  Future<void> _loadSession() async {
    _currentUser = _client.auth.currentUser;
    notifyListeners();
  }

  // LOGIN
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      _currentUser = response.user;
      notifyListeners();
    } catch (e) {
      throw Exception('Login gagal: ${e.toString()}');
    }
  }

  // REGISTER
  Future<void> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Register gagal: user null');
      }

      await _client.from('profiles').insert({
        'id': user.id,
        'email': user.email,
        'username': username,
      });

      _currentUser = user;
      notifyListeners();
    } catch (e) {
      throw Exception('Register gagal: ${e.toString()}');
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _client.auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // AMBIL USERNAME
  Future<String> fetchUsername() async {
    final user = _currentUser;
    if (user == null) return '';

    // Ambil username dari tabel profiles
    final profile = await _client
        .from('profiles')
        .select('username')
        .eq('id', user.id)
        .maybeSingle();

    // profile bisa null jika tidak ada
    if (profile == null) return '';

    // cast Map supaya bisa ambil 'username'
    final Map<String, dynamic> data = profile as Map<String, dynamic>;
    return data['username'] as String? ?? '';
  }
}
