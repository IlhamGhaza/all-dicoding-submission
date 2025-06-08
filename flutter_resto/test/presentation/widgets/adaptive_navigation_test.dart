import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_resto/presentation/widgets/adaptive_navigation.dart';

void main() {
  group('AdaptiveNavigation Widget Tests', () {
    Widget makeTestableWidget({required Widget child}) {
      return MaterialApp(home: Scaffold(body: child));
    }

    testWidgets('Displays NavigationBar on small screens (mobile)', (
      WidgetTester tester,
    ) async {
      tester.binding.window.physicalSizeTestValue = const Size(
        500 * 2.0,
        1000 * 2.0,
      );
      tester.binding.window.devicePixelRatioTestValue = 2.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        makeTestableWidget(
          child: AdaptiveNavigation(
            selectedIndex: 0,
            onDestinationSelected: (index) {},
          ),
        ),
      );

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('Displays NavigationRail on medium screens (tablet)', (
      WidgetTester tester,
    ) async {
      tester.binding.window.physicalSizeTestValue = const Size(
        700 * 2.0,
        1000 * 2.0,
      );
      tester.binding.window.devicePixelRatioTestValue = 2.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        makeTestableWidget(
          child: AdaptiveNavigation(
            selectedIndex: 0,
            onDestinationSelected: (index) {},
          ),
        ),
      );

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isFalse);
    });

    testWidgets('Displays extended NavigationRail on large screens (desktop)', (
      WidgetTester tester,
    ) async {
      tester.binding.window.physicalSizeTestValue = const Size(
        900 * 2.0,
        1000 * 2.0,
      );
      tester.binding.window.devicePixelRatioTestValue = 2.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        makeTestableWidget(
          child: AdaptiveNavigation(
            selectedIndex: 0,
            onDestinationSelected: (index) {},
          ),
        ),
      );

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isTrue);
    });

    testWidgets('onDestinationSelected callback is called', (
      WidgetTester tester,
    ) async {
      int? selectedIndex;
      tester.binding.window.physicalSizeTestValue = const Size(
        500 * 2.0,
        1000 * 2.0,
      );
      tester.binding.window.devicePixelRatioTestValue = 2.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AdaptiveNavigation(
              selectedIndex: 0,
              onDestinationSelected: (index) {
                selectedIndex = index;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite).first);
      await tester.pump();

      expect(selectedIndex, 1);
    });
  });
}
