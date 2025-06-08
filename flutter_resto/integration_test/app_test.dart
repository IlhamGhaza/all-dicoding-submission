import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_resto/main.dart' as app;
import 'package:provider/provider.dart';
import 'package:flutter_resto/data/providers/restaurant_provider.dart';
import 'package:flutter_resto/data/services/api_service.dart';
import 'package:flutter_resto/core/providers/theme_provider.dart';
import 'package:flutter_resto/core/providers/settings_provider.dart';
import 'package:flutter_resto/core/providers/navigation_provider.dart';
import 'package:flutter_resto/data/providers/favorite_provider.dart';
import 'package:flutter_resto/presentation/widgets/restaurant_card.dart';
import 'package:flutter_resto/presentation/pages/restaurant_detail_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      final dbPath = await getDatabasesPath();
      final databaseFile = File(p.join(dbPath, 'restaurant_database.db'));
      if (await databaseFile.exists()) {
        await databaseFile.delete();

        debugPrint('Deleted existing test database: ${databaseFile.path}');
      }
    }
  });

  group('End-to-end app test', () {
    testWidgets('Full app navigation and feature test', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<RestaurantProvider>(
              create: (_) =>
                  RestaurantProvider(apiService: ApiService())
                    ..fetchRestaurants(),
            ),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
            ChangeNotifierProvider(create: (_) => NavigationProvider()),
            ChangeNotifierProvider(create: (_) => FavoriteProvider()),
          ],
          child: app.MyApp(),
        ),
      );

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
        reason: "Loading indicator on initial load",
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(
        find.byType(ListView),
        findsOneWidget,
        reason: "Restaurant list (ListView) after loading",
      );
      expect(
        find.byType(RestaurantCard),
        findsWidgets,
        reason: "RestaurantCards should be present",
      );

      Finder navigationContainerFinder;
      if (tester.widgetList(find.byType(NavigationRail)).isNotEmpty) {
        navigationContainerFinder = find.byType(NavigationRail);
        debugPrint("Test environment is using NavigationRail.");
      } else if (tester.widgetList(find.byType(NavigationBar)).isNotEmpty) {
        navigationContainerFinder = find.byType(NavigationBar);
        debugPrint("Test environment is using NavigationBar.");
      } else {
        await tester.pump();
        if (tester.widgetList(find.byType(NavigationRail)).isNotEmpty) {
          navigationContainerFinder = find.byType(NavigationRail);
          debugPrint(
            "Test environment is using NavigationRail (after one pump).",
          );
        } else if (tester.widgetList(find.byType(NavigationBar)).isNotEmpty) {
          navigationContainerFinder = find.byType(NavigationBar);
          debugPrint(
            "Test environment is using NavigationBar (after one pump).",
          );
        } else {
          fail(
            'Neither NavigationRail nor NavigationBar found. Ensure AdaptiveNavigation is rendered.',
          );
        }
      }

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      expect(
        find.byType(TextField),
        findsAtLeastNWidgets(1),
        reason: "Search TextField appears",
      );
      await tester.enterText(find.byType(TextField), 'Melting Pot');
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(
        find.byType(RestaurantCard),
        findsWidgets,
        reason: "Search results should be present",
      );

      final firstRestaurantCard = find.byType(RestaurantCard).first;
      final restaurantCardWidget = tester.widget<RestaurantCard>(
        firstRestaurantCard,
      );
      final restaurantId = restaurantCardWidget.restaurant.id;
      await tester.ensureVisible(firstRestaurantCard);
      await tester.tap(firstRestaurantCard);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(
        find.byType(RestaurantDetailPage),
        findsOneWidget,
        reason: "Restaurant detail page displayed",
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Hero && widget.tag == 'restaurant-$restaurantId',
        ),
        findsOneWidget,
        reason: "Hero image present",
      );

      final favoriteIconDetail = find.descendant(
        of: find.byType(SliverAppBar),
        matching: find.byIcon(Icons.favorite_border),
      );
      expect(
        favoriteIconDetail,
        findsOneWidget,
        reason: "Favorite border icon on detail app bar",
      );
      await tester.tap(favoriteIconDetail);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(SliverAppBar),
          matching: find.byIcon(Icons.favorite),
        ),
        findsOneWidget,
        reason: "Filled favorite icon in SliverAppBar after tap",
      );

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(
        find.byType(TextField),
        findsAtLeastNWidgets(1),
        reason: "Back to Search Page with TextField",
      );

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(
        find.byType(RestaurantCard),
        findsWidgets,
        reason: "Back to Home page with restaurant list",
      );

      final favoritesIconNav = find.descendant(
        of: navigationContainerFinder,
        matching: find.byIcon(Icons.favorite),
      );
      expect(
        favoritesIconNav,
        findsOneWidget,
        reason: "Favorites icon in navigation widget should be found",
      );
      await tester.tap(favoritesIconNav);
      await tester.pumpAndSettle();
      expect(
        find.byType(RestaurantCard),
        findsOneWidget,
        reason: "Favorited restaurant in Favorites page",
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      final settingsIconNav = find.descendant(
        of: navigationContainerFinder,
        matching: find.byIcon(Icons.settings),
      );
      expect(
        settingsIconNav,
        findsOneWidget,
        reason: "Settings icon in navigation widget should be found",
      );
      await tester.tap(settingsIconNav);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Settings'),
        ),
        findsOneWidget,
        reason: "Settings page AppBar title",
      );
    });
  });
}
