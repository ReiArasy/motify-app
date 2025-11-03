
// pages/home_page.dart
// Halaman utama: Hero card + PageView kutipan besar (diambil dari main.dart). :contentReference[oaicite:2]{index=2}

import 'package:flutter/material.dart';
import '/controller/quote_controller.dart';

class HomePage extends StatefulWidget {
  final QuoteController controller;
  const HomePage({Key? key, required this.controller}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder akan rebuild saat controller.notifyListeners dipanggil
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final quotes = widget.controller.filteredQuotes;
        return Column(
          children: [
            // Hero card: sapaan + tombol ke Explore
            Container(
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.green.shade50, Colors.green.shade100]),
                borderRadius: BorderRadius.circular(16),
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
                  SizedBox(width: 12),
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

            //pageView: setiap halaman/card menampilkan satu kutipan quotes
            Expanded(
              child: quotes.isEmpty
                  ? Center(child: Text('No quotes in this category', style: TextStyle(color: Colors.grey)))
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: quotes.length,
                      onPageChanged: (i) => setState(() => _currentPage = i),
                      itemBuilder: (ctx, i) {
                        final q = quotes[i];
                        final isFav = widget.controller.isFavorite(q);
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6))],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('"${q.text}"', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.green[900])),
                                      SizedBox(height: 18),
                                      Align(alignment: Alignment.centerRight, child: Text('- ${q.author}', style: TextStyle(color: Colors.grey[700]))),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => widget.controller.toggleFavorite(q),
                                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                                    label: Text(isFav ? 'Unfavorite' : 'Favorite'),
                                  ),
                                ],
                              )
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
