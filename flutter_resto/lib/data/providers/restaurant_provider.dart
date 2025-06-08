import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

enum ResultState { loading, hasData, error, noData }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  List<Restaurant> _restaurants = [];
  List<Restaurant> _searchResults = [];
  Restaurant? _selectedRestaurant;
  ResultState _state = ResultState.loading;
  ResultState _searchState = ResultState.loading;
  String _message = '';
  String _searchMessage = '';
  String _searchQuery = '';

  RestaurantProvider({required this.apiService});

  // Getters
  List<Restaurant> get restaurants => _restaurants;
  List<Restaurant> get searchResults => _searchResults;
  Restaurant? get selectedRestaurant => _selectedRestaurant;
  ResultState get state => _state;
  ResultState get searchState => _searchState;
  String get message => _message;
  String get searchMessage => _searchMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      _restaurants = await apiService.getRestaurants();
      _state = _restaurants.isEmpty ? ResultState.noData : ResultState.hasData;
      _message = '';
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = _getErrorMessage(e);
      debugPrint('Error fetching restaurants: $e');
      notifyListeners();
    }
  }

  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      _selectedRestaurant = await apiService.getRestaurantDetail(id);
      _state = ResultState.hasData;
      _message = '';
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = _getErrorMessage(e);
      debugPrint('Error fetching restaurant detail: $e');
      notifyListeners();
    }
  }

  Future<void> searchRestaurants(String query) async {
    try {
      _searchQuery = query;

      if (query.isEmpty) {
        _searchResults = [];
        _searchState = ResultState.noData;
        _searchMessage = '';
        notifyListeners();
        return;
      }

      _searchState = ResultState.loading;
      notifyListeners();

      _searchResults = await apiService.searchRestaurants(query);
      _searchState = _searchResults.isEmpty
          ? ResultState.noData
          : ResultState.hasData;
      _searchMessage = '';
      notifyListeners();
    } catch (e) {
      _searchState = ResultState.error;
      _searchMessage = _getErrorMessage(e);
      debugPrint('Error searching restaurants: $e');
      notifyListeners();
    }
  }

  Future<void> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      await apiService.addReview(id: id, name: name, review: review);
      await fetchRestaurantDetail(id);
    } catch (e) {
      _state = ResultState.error;
      _message = _getErrorMessage(e);
      debugPrint('Error adding review: $e');
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    _searchState = ResultState.noData;
    _searchMessage = '';
    notifyListeners();
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('Failed to host lookup')) {
      return 'No internet connection. Please check your connection and try again.';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Connection timeout. Please try again.';
    } else if (error.toString().contains('Failed to load')) {
      return 'Unable to load data. Please try again later.';
    } else if (error.toString().contains('Failed to search')) {
      return 'Search failed. Please try again.';
    } else if (error.toString().contains('Failed to add review')) {
      return 'Failed to add review. Please try again.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
}
