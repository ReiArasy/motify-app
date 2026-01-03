// pages/favorites_page.dart
import 'package:flutter/material.dart';
import '/controller/quote_controller.dart';
import '/models/quote.dart';
import '/widgets/quote_card.dart';

class FavoritesPage extends StatelessWidget {
  final QuoteController controller;
  const FavoritesPage({Key? key, required this.controller}) : super(key: key);

  // fungsi untuk menampilkan tampilan kosong (ketika belum ada favorite)
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border,
              size: 56, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text('No favorites yet',
              style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  // dialog detail quote
  void _showDetailDialog(BuildContext context, Quote q) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '"${q.text}"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                '- ${q.author ?? "Anon"}',
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // grid favorites
  Widget _buildGrid(BuildContext context, List<Quote> favorites) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: favorites.length,
        itemBuilder: (ctx, i) {
          final q = favorites[i];
          return QuoteCard(
            quote: q,
            isFavorite: true,
            // toggle favorite sekarang berbasis quote.id
            onFavorite: () =>
                controller.toggleFavorite(q.id),
            onTap: () => _showDetailDialog(context, q),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // fetch favorite saat pertama render
    controller.fetchFavoriteQuotes();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final favorites = controller.favoriteQuotes;

        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return favorites.isEmpty
            ? _buildEmpty()
            : _buildGrid(context, favorites);
      },
    );
  }
}
