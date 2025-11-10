// Controller yang mengelola state aplikasi secara sederhana.
// Meng-extend ChangeNotifier supaya widget bisa listen dan rebuild saat data berubah.

import 'package:flutter/foundation.dart';
import '../models/quote.dart';
import '../data/demo_quotes.dart';

class QuoteController extends ChangeNotifier {
  // semua quotes
  final List<Quote> _allQuotes = List.from(semuaquotes);
  // favorite quote dikelola di sini
  final List<Quote> _favorites = [];

  // default kategori awal yang dipilih
  String _selectedCategory = 'All';

  // getter untuk membaca state
  List<Quote> get allQuotes => List.unmodifiable(_allQuotes);
  List<Quote> get favorites => List.unmodifiable(_favorites);
  String get selectedCategory => _selectedCategory;

  // filter quotes berdasarkan kategori aktif
  List<Quote> get filteredQuotes {
    if (_selectedCategory == 'All') return allQuotes;
    return allQuotes.where((q) => q.category == _selectedCategory).toList();
  }

  //manage favorite
  bool isFavorite(Quote q) => _favorites.contains(q);

  // toggle favorite
  void toggleFavorite(Quote q) {
    if (_favorites.contains(q))
      _favorites.remove(q);
    else
      _favorites.add(q);
    notifyListeners(); // beri tahu listener untuk rebuild
  }

  // set kategori dan ini adalah method untuk memberitahu kalau semisal kita ingin select category maka method ini yang dijalankan
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
