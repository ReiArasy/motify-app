// pages/favorites_page.dart
import 'package:flutter/material.dart';
import '/controller/quote_controller.dart';
import '/models/quote.dart';
import '/widgets/quote_card.dart';

class FavoritesPage extends StatelessWidget {
  final QuoteController controller;
  const FavoritesPage({Key? key, required this.controller}) : super(key: key);

  // fungsi untuk menampilkan tampilan kosong (ketika belum ada favorite)
  // dipanggil saat list favorites kosong
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border, size: 56, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text('No favorites yet', style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  // fungsi untuk menampilkan dialog detail quote
  // dialog ini muncul ketika pengguna men-tap salah satu kartu quote
  void _showDetailDialog(BuildContext context, Quote q) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        // bentuk dialog dibuat melengkung agar tampil modern
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // menampilkan isi teks quote
              Text('"${q.text}"',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              // menampilkan nama author di bagian kanan
              Text('- ${q.author}',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.grey[700])),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // fungsi utama untuk membangun tampilan grid favorites
  // menampilkan semua item favorite dalam bentuk grid dua kolom
  Widget _buildGrid(BuildContext context, List<Quote> favorites) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        // mengatur tata letak grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // jumlah kolom dalam grid
          childAspectRatio: 0.85, // rasio lebar–tinggi tiap kartu
          crossAxisSpacing: 12, // jarak antar kolom
          mainAxisSpacing: 12, // jarak antar baris
        ),
        itemCount: favorites.length, // jumlah item yang akan ditampilkan
        itemBuilder: (ctx, i) {
          final q = favorites[i];
          return QuoteCard(
            quote: q, // data quote yang akan ditampilkan
            isFavorite: true, // status kartu adalah favorite
            // tombol favorite akan memanggil toggleFavorite() dari controller
            onFavorite: () => controller.toggleFavorite(q),
            // klik kartu akan menampilkan dialog detail
            onTap: () => _showDetailDialog(context, q),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // animatedBuilder dipakai agar halaman ikut berubah saat controller berubah
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final favorites = controller.favorites;
        // jika list kosong → tampilkan tampilan kosong (_buildEmpty)
        // jika ada data → tampilkan grid quote (_buildGrid)
        return favorites.isEmpty
            ? _buildEmpty()
            : _buildGrid(context, favorites);
      },
    );
  }
}
