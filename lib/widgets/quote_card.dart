import 'package:flutter/material.dart';
import '/models/quote.dart';

/// widget stateless yang menampilkan satu kutipan (quote)
/// Didesain agar bisa digunakan ulang di berbagai halaman seperti Home & Explore.
class QuoteCard extends StatelessWidget {
  /// data utama berupa objek (berisi teks dan author).
  final Quote quote;

  /// callback dijalankan saat tombol favorite ditekan.
  final VoidCallback? onFavorite;

  /// menandai apakah quote ini termasuk favorit.
  final bool isFavorite;

  /// callback saat seluruh kartu ditekan (misalnya untuk membuka dialog detail).
  final VoidCallback? onTap;

  const QuoteCard({
    Key? key,
    required this.quote,
    this.onFavorite,
    this.isFavorite = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // menangani interaksi tap di seluruh area kartu
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // efek bayangan lembut agar tampak seperti kartu
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),

        // isi kartu ditata vertikal: teks quote, lalu nama penulis + tombol favorit
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // teks utama quote
            Expanded(
              child: Text(
                '"${quote.text}"',
                maxLines: 6,
                overflow: TextOverflow.ellipsis, // potong teks panjang dengan "..."
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.green[900],
                ),
              ),
            ),
            
            SizedBox(height: 8),

            // baris bawah: nama author, tombol favorite
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // nama penulis
                Text(
                  quote.author,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),

                // tombol favorite
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(), // hilangkan padding default
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.redAccent,
                  ),
                  onPressed: onFavorite,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
