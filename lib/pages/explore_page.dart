import 'package:flutter/material.dart';
import '/controller/quote_controller.dart';
import '/widgets/quote_card.dart';

class ExplorePage extends StatefulWidget {
  final QuoteController controller;

  const ExplorePage({Key? key, required this.controller}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // kategori khusus Explore
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadExploreQuotes();
  }

  Future<void> _loadExploreQuotes() async {
    await widget.controller.fetchExploreQuotes();
    widget.controller.fetchFavoriteQuotes();
  }

  void _onCategoryChanged(String category) async {
    setState(() {
      selectedCategory = category;
    });
    await widget.controller.fetchExploreQuotes(); // refresh quotes dari user lain
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // filter ExploreQuotes berdasarkan kategori aktif
        final quotes = selectedCategory == 'All'
            ? controller.exploreQuotes
            : controller.exploreQuotes
                .where((q) => q.category == selectedCategory)
                .toList();

        final categories = ['All', 'motivasi', 'pelajaran', 'kehidupan', 'karir'];

        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // pilihan kategori
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (ctx, idx) {
                    final c = categories[idx];
                    final active = c == selectedCategory;
                    return ChoiceChip(
                      label: Text(c),
                      selected: active,
                      onSelected: (_) => _onCategoryChanged(c),
                      selectedColor: Colors.green[100],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // grid quotes
              Expanded(
                child: quotes.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada quote dari pengguna lain',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: quotes.length,
                        itemBuilder: (ctx, i) {
                          final q = quotes[i];
                          final isFav = controller.isFavorite(q.id);

                          return QuoteCard(
                            quote: q,
                            isFavorite: isFav,
                            onFavorite: () => controller.toggleFavorite(q.id),
                            onTap: () {
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
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
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
