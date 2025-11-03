// widgets/quote_card.dart
// Komponen reusable untuk menampilkan sebuah kutipan dalam bentuk kartu.

import 'package:flutter/material.dart';
import '/models/quote.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback? onFavorite;
  final bool isFavorite;
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
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '"${quote.text}"',
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.green[900],
                ),
              ),
            ),
            
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  quote.author,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
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
