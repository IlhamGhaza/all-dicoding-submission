import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/navigation_provider.dart';
import '../../data/providers/restaurant_provider.dart';
import '../widgets/adaptive_navigation.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_detail_page.dart';
import 'search_page.dart';
import 'favorites_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget _buildCurrentPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return _buildRestaurantList();
      case 1:
        return const FavoritesPage();
      case 2:
        return const SettingsPage();
      default:
        return _buildRestaurantList();
    }
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantProvider>(
        context,
        listen: false,
      ).fetchRestaurants();
    });
  }
  Widget _buildRestaurantList() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (_, provider, _) {
          if (provider.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.state == ResultState.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchRestaurants(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          } else if (provider.state == ResultState.noData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No restaurants found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => provider.fetchRestaurants(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = provider.restaurants[index];
                  return RestaurantCard(
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RestaurantDetailPage(restaurantId: restaurant.id),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();

    return AdaptiveScaffold(
      selectedIndex: navProvider.selectedIndex,
      onDestinationSelected: (index) {
        context.read<NavigationProvider>().onDestinationSelected(index);
      },
      body: _buildCurrentPage(navProvider.selectedIndex),
    );
  }
}
