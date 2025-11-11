import 'package:flutter/material.dart';
import '/controller/quote_controller.dart';
import '/models/quote.dart';
import '/widgets/quote_card.dart'; // Komponen tampilan kartu quote

// halaman ExplorePage menampilkan daftar quote berdasarkan kategori tertentu
class ExplorePage extends StatefulWidget {
  final QuoteController controller;

  const ExplorePage({Key? key, required this.controller}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    // mengambil controller dari widget utama
    final controller = widget.controller;

    // AnimatedBuilder berfungsi untuk rebuild tampilan otomatis
    // setiap kali ada perubahan data di controller
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // Mengambil daftar quote yang sudah difilter sesuai kategori
        final quotes = controller.filteredQuotes;

        // daftar kategori yang bisa dipilih
        final categories = ['All', 'motivasi', 'pelajaran', 'kehidupan', 'karir'];

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [

              // bagian pilihan kategori (chip)
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (ctx, idx) {
                    final c = categories[idx];
                    final active = c == controller.selectedCategory;
                    return ChoiceChip(
                      label: Text(c),
                      selected: active,
                      // ketika chip diklik maka akan diubah kategori yang sedang aktif
                      onSelected: (_) => controller.setSelectedCategory(c),
                      selectedColor: Colors.green[100],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // grid yang menampilkan daftar QuoteCard
              Expanded(
                child: quotes.isEmpty
                    // jika tidak ada quote di kategori itu maka akan menampilkan teks kosong
                    ? const Center(
                        child: Text(
                          'Motivasi tanpa aksi hanyalah halusinasi, maaf quotes kategori ini tidak tersedia',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )

                    // jika ada quote, maka akan ditampilkan dalam bentuk grid
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // jumlah kolom 2
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: quotes.length,
                        itemBuilder: (ctx, i) {
                          final q = quotes[i];
                          return QuoteCard(
                            quote: q,
                            isFavorite: controller.isFavorite(q),
                            // tombol favorite
                            onFavorite: () => controller.toggleFavorite(q),

                            // saat kartu di-tap maka akan membuka dialog detail quote
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        // teks utama quote
                                        Text(
                                          '"${q.text}"',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        // nama penulis quote
                                        Text(
                                          '- ${q.author}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(color: Colors.grey[700]),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
