import 'package:flutter/material.dart';
import '/controller/quote_controller.dart';
import '/widgets/quote_card.dart';

/// HomePage: menampilkan sapaan (hero card) dan PageView berisi quotes.
/// widget Stateful karena menyimpan PageController dan index halaman saat ini.
class HomePage extends StatefulWidget {
  final QuoteController controller;

  const HomePage({Key? key, required this.controller}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // pagecontroller mengatur PageView (posisi dan navigasinya).
  final PageController _pageController = PageController();

  // menyimpan index halaman yang sedang aktif (dipakai untuk indikator).
  int _currentPage = 0;

  @override
  void dispose() {
    // controller agar tidak terjadi memory leak.
    _pageController.dispose();
    super.dispose();
  }

  // tampilan dialog detail quote (dipanggil dari onTap quotecard)
  void _showQuoteDialog(BuildContext context, q) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              // nama penulis quote
              Text('- ${q.author}', textAlign: TextAlign.right, style: TextStyle(color: Colors.grey[700])),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // animatedBuilder di sini "mendengarkan" perubahan pada QuoteController.
    // ketika controller memanggil notifyListeners(), builder akan dijalankan ulang.
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        // ambil daftar quotes yang sudah difilter sesuai kategori aktif di controller.
        final quotes = widget.controller.filteredQuotes;

        return Column(
          children: [
            // hero card
            Container(
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.green.shade50, Colors.green.shade100]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Day, Arasy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[900])),
                        Text('Kata-kata hari ini', style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // ikon kecil di kanan hero
                  // widget rounded di dalam container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 84,
                      height: 84,
                      color: Colors.green[200],
                      child: Icon(Icons.auto_stories, size: 40, color: Colors.green[900]),
                    ),
                  )

                ],
              ),
            ),

            // expanded ini berfungsi bahwa widget anaknya harus mengambil ruang sebanyak mungkin di sumbu utama column, row.
            // pageview: setiap card menampilkan 1 quote
            Expanded(
              child: quotes.isEmpty
                  ? Center(child: Text('Kategori ini tidak terdapat quote', style: TextStyle(color: Colors.grey)))
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: quotes.length,
                      // saat swipe ke halaman lain, maka akan di update _currentPage untuk state lokal
                      onPageChanged: (i) => setState(() => _currentPage = i),
                      itemBuilder: (ctx, i) {
                        final q = quotes[i];

                        // isFavorite diambil dari controller
                        // controller menangani daftar favorite
                        final isFav = widget.controller.isFavorite(q);

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // implement komponen QuoteCard reusable 
                              Expanded(
                                child: QuoteCard(
                                  quote: q,
                                  isFavorite: isFav,
                                  onFavorite: () => widget.controller.toggleFavorite(q),
                                  onTap: () => _showQuoteDialog(context, q),
                                ),
                              ),

                              SizedBox(height: 12),
                            ],
                          ),
                        );
                      },
                    ),
            )
          ],
        );
      },
    );
  }
}
