import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_resto/data/providers/restaurant_provider.dart';
import 'package:flutter_resto/data/services/api_service.dart';
import 'package:flutter_resto/data/models/restaurant.dart';

@GenerateMocks([ApiService])
import 'restaurant_provider_test.mocks.dart';

void main() {
  late MockApiService mockApiService;
  late RestaurantProvider provider;

  setUp(() {
    mockApiService = MockApiService();
    provider = RestaurantProvider(apiService: mockApiService);
  });

  group('RestaurantProvider Tests', () {
    test('Initial state should be loading', () {
      expect(provider.state, equals(ResultState.loading));
    });

    test('Should return restaurants when API call is successful', () async {
      final mockRestaurants = [
        Restaurant(
          id: '1',
          name: 'Test Restaurant',
          description: 'Test Description',
          pictureId: 'test.jpg',
          city: 'Test City',
          address: 'Test Address',
          rating: 4.5,
          categories: [],
          customerReviews: [],
        ),
      ];

      when(
        mockApiService.getRestaurants(),
      ).thenAnswer((_) async => mockRestaurants);

      await provider.fetchRestaurants();

      expect(provider.state, equals(ResultState.hasData));
      expect(provider.restaurants, equals(mockRestaurants));
    });

    test('Should return error state when API call fails', () async {
      when(
        mockApiService.getRestaurants(),
      ).thenThrow(Exception('Failed to load restaurants'));

      await provider.fetchRestaurants();

      expect(provider.state, equals(ResultState.error));
      expect(provider.message, isNotEmpty);
    });
  });
}
