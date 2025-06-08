import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/restaurant_provider.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Clear previous search when entering search page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantProvider>(context, listen: false).clearSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    Provider.of<RestaurantProvider>(
      context,
      listen: false,
    ).searchRestaurants(query);
  }

  void _onClear() {
    _searchController.clear();
    Provider.of<RestaurantProvider>(context, listen: false).clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search restaurants...',
            border: InputBorder.none,
            suffixIcon: Consumer<RestaurantProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  icon: Icon(
                    provider.searchQuery.isNotEmpty
                        ? Icons.clear
                        : Icons.search,
                  ),
                  onPressed: provider.searchQuery.isNotEmpty ? _onClear : null,
                );
              },
            ),
          ),
          onChanged: (value) {
            // Add debouncing to avoid too many API calls
            if (value.length >= 3 || value.isEmpty) {
              _onSearch(value);
            }
          },
          onSubmitted: _onSearch,
        ),
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          if (provider.searchQuery.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Enter a restaurant name to search',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (provider.searchState == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.searchState == ResultState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    provider.searchMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _onSearch(provider.searchQuery),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (provider.searchState == ResultState.noData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.restaurant_menu,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No restaurants found for "${provider.searchQuery}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.searchResults.length,
              itemBuilder: (context, index) {
                final restaurant = provider.searchResults[index];
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
            );
          }
        },
      ),
    );
  }
}
