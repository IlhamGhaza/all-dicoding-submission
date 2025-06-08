import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/restaurant.dart';

class FavoriteProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Restaurant> _favorites = [];
  bool _isLoading = false;

  FavoriteProvider() {
    loadFavorites();
  }

  List<Restaurant> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<Map<String, dynamic>> results = await _databaseHelper
          .getFavorites();
      _favorites = results.map((data) => Restaurant.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    try {
      await _databaseHelper.insertFavorite(restaurant);
      _favorites.add(restaurant);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding favorite: $e');
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await _databaseHelper.removeFavorite(id);
      _favorites.removeWhere((restaurant) => restaurant.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  bool isRestaurantFavorite(String id) {
    return _favorites.any((restaurant) => restaurant.id == id);
  }

  Future<bool> isFavorite(String id) async {
    try {
      return await _databaseHelper.isFavorite(id);
    } catch (e) {
      debugPrint('Error checking favorite status: $e');
      return false;
    }
  }
}
