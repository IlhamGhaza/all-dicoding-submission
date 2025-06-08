import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_resto/data/models/restaurant.dart';
import 'package:flutter_resto/presentation/widgets/restaurant_card.dart';

void main() {
  testWidgets('RestaurantCard displays restaurant information correctly', (
    WidgetTester tester,
  ) async {
    final restaurant = Restaurant(
      id: '1',
      name: 'Test Restaurant',
      description: 'Test Description',
      pictureId: 'test.jpg',
      city: 'Test City',
      address: 'Test Address',
      rating: 4.5,
      categories: [],
      customerReviews: [],
    );

    bool onTapCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RestaurantCard(
            restaurant: restaurant,
            onTap: () {
              onTapCalled = true;
            },
          ),
        ),
      ),
    );

    // Verify restaurant name is displayed
    expect(find.text('Test Restaurant'), findsOneWidget);

    // Verify city is displayed
    expect(find.text('Test City'), findsOneWidget);

    // Verify rating is displayed
    expect(find.text('4.5'), findsOneWidget);

    // Verify description is displayed
    expect(find.text('Test Description'), findsOneWidget);

    // Test onTap callback
    await tester.tap(find.byType(RestaurantCard));
    await tester.pump();
    expect(onTapCalled, true);
  });
}
