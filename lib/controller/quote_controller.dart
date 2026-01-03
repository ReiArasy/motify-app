import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quote.dart';

class QuoteController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // STATE
  List<Quote> _myQuotes = [];
  List<Quote> _exploreQuotes = [];
  List<Quote> _favoriteQuotes = [];

  bool _isLoading = false;
  String _selectedCategory = 'All';

  // GETTER
  List<Quote> get myQuotes => List.unmodifiable(_myQuotes);
  List<Quote> get exploreQuotes => List.unmodifiable(_exploreQuotes);
  List<Quote> get favoriteQuotes => List.unmodifiable(_favoriteQuotes);

  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  String? get _userId => _supabase.auth.currentUser?.id;

  // FILTER
  List<Quote> get filteredMyQuotes {
    if (_selectedCategory == 'All') return myQuotes;
    return myQuotes.where((q) => q.category == _selectedCategory).toList();
  }

  List<Quote> get filteredExploreQuotes {
    if (_selectedCategory == 'All') return exploreQuotes;
    return exploreQuotes
        .where((q) => q.category == _selectedCategory)
        .toList();
  }

  // HELPER
  void _setLoading(bool value) {
    _isLoading = value;
  }

  void _refreshUI() {
    notifyListeners();
  }

  // FETCH DATA
  Future<void> fetchMyQuotes() async {
    if (_userId == null) return;

    _setLoading(true);
    _refreshUI();

    try {
      final data = await _supabase
          .from('quotes')
          .select()
          .eq('user_id', _userId!)
          .order('created_at', ascending: false);

      _myQuotes = data.map<Quote>((e) => Quote.fromJson(e)).toList();
    } catch (e) {
      debugPrint('fetchMyQuotes error: $e');
    }

    _setLoading(false);
    _refreshUI();
  }

  /// Explore quotes termasuk milik user login
  Future<void> fetchExploreQuotes() async {
    _setLoading(true);
    _refreshUI();

    try {
      final data = await _supabase
          .from('quotes')
          .select()
          .order('created_at', ascending: false); // ambil semua

      _exploreQuotes = data.map<Quote>((e) => Quote.fromJson(e)).toList();
      _refreshUI();
    } catch (e) {
      debugPrint('fetchExploreQuotes error: $e');
    }

    _setLoading(false);
    _refreshUI();
  }

  Future<void> fetchFavoriteQuotes() async {
    if (_userId == null) return;

    try {
      final data = await _supabase
          .from('favorites')
          .select('quotes(*)')
          .eq('user_id', _userId!);

      _favoriteQuotes =
          data.map<Quote>((e) => Quote.fromJson(e['quotes'])).toList();

      _refreshUI();
    } catch (e) {
      debugPrint('fetchFavoriteQuotes error: $e');
    }
  }

  // CRUD QUOTE
  Future<void> addQuote({
    required String text,
    String? author,
    String? category,
  }) async {
    if (_userId == null) return;

    try {
      await _supabase.from('quotes').insert({
        'user_id': _userId!,
        'text': text,
        'author': author,
        'category': category,
      });

      await fetchMyQuotes();
      await fetchExploreQuotes();
    } catch (e) {
      debugPrint('addQuote error: $e');
    }
  }

  Future<void> updateQuote({
    required String quoteId,
    required String text,
    String? author,
    String? category,
  }) async {
    if (_userId == null) return;

    try {
      await _supabase
          .from('quotes')
          .update({
            'text': text,
            'author': author,
            'category': category,
          })
          .eq('id', quoteId)
          .eq('user_id', _userId!);

      await fetchMyQuotes();
      await fetchExploreQuotes();
    } catch (e) {
      debugPrint('updateQuote error: $e');
    }
  }

  Future<void> deleteQuote(String quoteId) async {
    if (_userId == null) return;

    try {
      await _supabase
          .from('quotes')
          .delete()
          .eq('id', quoteId)
          .eq('user_id', _userId!);

      await fetchMyQuotes();
      await fetchExploreQuotes();
      await fetchFavoriteQuotes();
    } catch (e) {
      debugPrint('deleteQuote error: $e');
    }
  }

  // FAVORITE
  bool isFavorite(String quoteId) {
    return _favoriteQuotes.any((q) => q.id == quoteId);
  }

  Future<void> toggleFavorite(String quoteId) async {
    if (_userId == null) return;

    try {
      final existing = await _supabase
          .from('favorites')
          .select()
          .eq('user_id', _userId!)
          .eq('quote_id', quoteId)
          .maybeSingle();

      if (existing == null) {
        await _supabase.from('favorites').insert({
          'user_id': _userId!,
          'quote_id': quoteId,
        });
      } else {
        await _supabase
            .from('favorites')
            .delete()
            .eq('user_id', _userId!)
            .eq('quote_id', quoteId);
      }

      await fetchFavoriteQuotes();
    } catch (e) {
      debugPrint('toggleFavorite error: $e');
    }
  }

  // KATEGORI
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    _refreshUI();
  }
}
