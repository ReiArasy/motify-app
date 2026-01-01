import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';

/// AuthController
/// ------------------------------------------------------------
/// Controller ini bertugas menangani:
/// - Autentikasi user (login, register, logout)
/// - Menyimpan state user login
/// - Sinkronisasi user auth Supabase → tabel profiles
///
/// Controller ini EXTENDS ChangeNotifier agar:
/// UI bisa rebuild otomatis saat status login berubah
class AuthController extends ChangeNotifier {
  /// Supabase client (singleton dari SupabaseFlutter)
  final SupabaseClient _client = SupabaseClientService.client;

  /// Menyimpan user yang sedang login
  User? _currentUser;

  /// Getter user (dipakai UI / guard)
  User? get currentUser => _currentUser;

  /// Status login user
  bool get isLoggedIn => _currentUser != null;

  /// Constructor
  /// Saat controller dibuat, langsung cek apakah user
  /// sudah login sebelumnya (session tersimpan)
  AuthController() {
    _loadSession();
  }

  /// ------------------------------------------------------------
  /// Load session dari Supabase
  /// ------------------------------------------------------------
  /// Supabase otomatis menyimpan session login.
  /// Method ini memastikan app tahu:
  /// - user sudah login → langsung masuk Home
  /// - user belum login → diarahkan ke Login
  Future<void> _loadSession() async {
    _currentUser = _client.auth.currentUser;
    notifyListeners();
  }

  /// ------------------------------------------------------------
  /// LOGIN
  /// ------------------------------------------------------------
  /// Login menggunakan email & password
  ///
  /// Jika berhasil:
  /// - Supabase membuat session
  /// - _currentUser diisi
  /// - UI akan rebuild otomatis
  ///
  /// Jika gagal:
  /// - Lempar Exception (ditangkap di UI)
  Future<void> login({
    required String email,
    required String password,
  }) async {
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

  /// ------------------------------------------------------------
  /// REGISTER
  /// ------------------------------------------------------------
  /// Register user baru:
  /// 1. Membuat akun di Supabase Auth
  /// 2. Insert data tambahan ke tabel profiles
  ///
  /// CATATAN:
  /// - Supabase Auth hanya menyimpan email & password
  /// - Data seperti username HARUS disimpan di tabel profiles
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

      /// Insert ke tabel profiles
      /// --------------------------------------------------------
      /// Ini PENTING karena:
      /// auth.users ≠ data profil user
      /// profiles = data publik user (username, dll)
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

  /// ------------------------------------------------------------
  /// LOGOUT
  /// ------------------------------------------------------------
  /// Menghapus session login Supabase
  /// dan reset state user di aplikasi
  Future<void> logout() async {
    await _client.auth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
