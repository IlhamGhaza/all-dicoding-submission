import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/state/api_state.dart';
import '../../core/constant.dart';
import '../../data/models/story_model.dart';
import '../../data/services/api_service.dart';
import '../../data/services/storage_service.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  ApiState<List<Story>> _storiesState = const ApiInitial();
  ApiState<bool> _addStoryState = const ApiInitial();
  ApiState<List<Story>> _moreStoriesState = const ApiInitial();

  List<Story> _stories = [];
  int _currentPage = 1;
  bool _hasMoreStories = true;
  bool _isFetchingMore = false;

  ApiState<List<Story>> get storiesState => _storiesState;
  ApiState<bool> get addStoryState => _addStoryState;
  ApiState<List<Story>> get moreStoriesState => _moreStoriesState;
  List<Story> get stories => _stories;
  bool get hasMoreStories => _hasMoreStories;
  bool get isFetchingMore => _isFetchingMore;

  Future<void> getStories({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _stories = [];
      _hasMoreStories = true;
    }

    _storiesState = const ApiLoading();
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      if (token == null) {
        _storiesState = const ApiError(
            'Authentication token not found. Please login again.');
        notifyListeners();
        return;
      }

      final newStories =
          await _apiService.getStories(token, page: _currentPage);
      if (newStories.isEmpty || newStories.length < AppConstants.pageSize) {
        _hasMoreStories = false;
      }
      _stories.addAll(newStories);
      _storiesState = ApiSuccess(_stories);
      notifyListeners();
    } catch (e) {
      _storiesState = ApiError(e.toString());
      notifyListeners();
    }
  }

  Future<void> fetchMoreStories() async {
    if (_isFetchingMore || !_hasMoreStories) return;

    _isFetchingMore = true;
    _moreStoriesState = const ApiLoading();
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      if (token == null) {
        _moreStoriesState = const ApiError('Authentication token not found.');
        _isFetchingMore = false;
        notifyListeners();
        return;
      }

      _currentPage++;
      final newStories =
          await _apiService.getStories(token, page: _currentPage);

      if (newStories.isEmpty || newStories.length < AppConstants.pageSize) {
        _hasMoreStories = false;
      }
      _stories.addAll(newStories);
      _moreStoriesState = ApiSuccess(_stories);
    } catch (e) {
      _moreStoriesState = ApiError(e.toString());
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<void> addStory(String description, File imageFile,
      {double? lat, double? lon}) async {
    _addStoryState = const ApiLoading();
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      if (token == null) {
        _addStoryState = const ApiError('Token not found');
        notifyListeners();
        return;
      }

      final success = await _apiService.addStory(token, description, imageFile,
          lat: lat, lon: lon);
      _addStoryState = ApiSuccess(success);

      if (success) {
        await getStories(isRefresh: true);
      }

      notifyListeners();
    } catch (e) {
      _addStoryState = ApiError(e.toString());
      notifyListeners();
    }
  }

  void resetAddStoryState() {
    _addStoryState = const ApiInitial();
    notifyListeners();
  }
}
