import 'package:flutter/material.dart';
import '/controller/quote_controller.dart';
import '/controller/auth_controller.dart';
import '/widgets/quote_card.dart';
import '/models/quote.dart';

class HomePage extends StatefulWidget {
  final QuoteController controller;
  final AuthController authController;

  const HomePage({
    Key? key,
    required this.controller,
    required this.authController,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String username = ''; // untuk username user login

  @override
  void initState() {
    super.initState();
    widget.controller.fetchMyQuotes();
    widget.controller.fetchFavoriteQuotes();
    _loadUsername();
  }

  /// Ambil username user dari AuthController
  Future<void> _loadUsername() async {
    final userName = await widget.authController.fetchUsername();
    if (mounted) {
      setState(() {
        username = userName;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showQuoteDialog(BuildContext context, Quote q) {
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
              Text(
                '"${q.text}"',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                '- ${q.author ?? "Anon"}',
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddEditQuoteSheet({Quote? quote}) {
    final textController = TextEditingController(text: quote?.text ?? '');
    final authorController = TextEditingController(text: quote?.author ?? '');
    String category = quote?.category ?? 'motivasi';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quote == null ? 'Tambah Quote' : 'Edit Quote',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Isi Quote',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(
                labelText: 'Author (opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: category,
              items: const [
                DropdownMenuItem(value: 'motivasi', child: Text('Motivasi')),
                DropdownMenuItem(value: 'pelajaran', child: Text('Pelajaran')),
                DropdownMenuItem(value: 'kehidupan', child: Text('Kehidupan')),
                DropdownMenuItem(value: 'karir', child: Text('Karir')),
              ],
              onChanged: (v) => category = v!,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (textController.text.trim().isEmpty) return;

                  if (quote == null) {
                    await widget.controller.addQuote(
                      text: textController.text,
                      author: authorController.text,
                      category: category,
                    );
                  } else {
                    await widget.controller.updateQuote(
                      quoteId: quote.id,
                      text: textController.text,
                      author: authorController.text,
                      category: category,
                    );
                  }

                  if (mounted) Navigator.pop(context);
                },
                child: Text(quote == null ? 'Tambah' : 'Simpan'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Quote quote) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Quote'),
        content: const Text('Quote ini akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.controller.deleteQuote(quote.id);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final quotes = widget.controller.filteredMyQuotes;

        if (widget.controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () => _showAddEditQuoteSheet(),
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              // HERO
              Container(
                margin: const EdgeInsets.all(30),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade50, Colors.green.shade100],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, 4))
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Good Day, $username',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[900])),
                          Text('Kata-kata hari ini',
                              style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
                    ),
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.auto_stories,
                          size: 40, color: Colors.green[900]),
                    )
                  ],
                ),
              ),

              // PAGEVIEW
              Expanded(
                child: quotes.isEmpty
                    ? const Center(
                        child: Text('Belum ada quote yang kamu buat',
                            style: TextStyle(color: Colors.grey)),
                      )
                    : PageView.builder(
                        controller: _pageController,
                        itemCount: quotes.length,
                        onPageChanged: (i) => setState(() => _currentPage = i),
                        itemBuilder: (ctx, i) {
                          final q = quotes[i];
                          final isFav = widget.controller.isFavorite(q.id);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            child: GestureDetector(
                              onLongPress: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (ctx) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.edit),
                                        title: const Text('Edit'),
                                        onTap: () {
                                          Navigator.pop(ctx);
                                          _showAddEditQuoteSheet(quote: q);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.delete,
                                            color: Colors.red),
                                        title: const Text('Hapus'),
                                        onTap: () {
                                          Navigator.pop(ctx);
                                          _confirmDelete(q);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: QuoteCard(
                                quote: q,
                                isFavorite: isFav,
                                onFavorite: () =>
                                    widget.controller.toggleFavorite(q.id),
                                onTap: () => _showQuoteDialog(context, q),
                              ),
                            ),
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
