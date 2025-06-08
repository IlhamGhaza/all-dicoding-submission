class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String address;
  final double rating;
  final Menu? menus; // Made nullable
  final List<Category> categories;
  final List<Review> customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.address,
    required this.rating,
    this.menus,
    required this.categories,
    required this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      pictureId: json['pictureId'] as String? ?? '',
      city: json['city'] as String? ?? '',
      address: json['address'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      // Add null check for menus
      menus: json['menus'] != null
          ? Menu.fromJson(json['menus'] as Map<String, dynamic>)
          : null,
      categories:
          (json['categories'] as List?)
              ?.map(
                (category) =>
                    Category.fromJson(category as Map<String, dynamic>),
              )
              .toList() ??
          [],
      // Add null check for customerReviews
      customerReviews: json['customerReviews'] != null
          ? (json['customerReviews'] as List)
                .map(
                  (review) => Review.fromJson(review as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }

  String get imageUrl {
    return 'https://restaurant-api.dicoding.dev/images/medium/$pictureId';
  }
}

class Menu {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menu({required this.foods, required this.drinks});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      // Add null checks for foods and drinks arrays
      foods: json['foods'] != null
          ? (json['foods'] as List)
                .map((food) => MenuItem.fromJson(food as Map<String, dynamic>))
                .toList()
          : [],
      drinks: json['drinks'] != null
          ? (json['drinks'] as List)
                .map(
                  (drink) => MenuItem.fromJson(drink as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }
}

class MenuItem {
  final String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(name: json['name'] as String? ?? '');
  }
}

class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name'] as String);
  }
}

class Review {
  final String name;
  final String review;
  final String date;

  Review({required this.name, required this.review, required this.date});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      name: json['name'] as String? ?? '',
      review: json['review'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );
  }
}
