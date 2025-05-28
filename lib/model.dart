class Product {
  final int id;
  final String name;
  final String description;
  final String img;
  final double price;
  final String priceTagline;
  final List<String> tags;
  int quantity; // mutable, quantity might change in cart
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.img,
    required this.price,
    required this.priceTagline,
    required this.tags,
    this.quantity = 1,
    required this.category,
  });

  // Create a Product instance from JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      img: json['img'] as String,
      price: (json['price'] as num).toDouble(),
      priceTagline: json['price-tagline'] as String,
      tags: List<String>.from(json['tags']),
      quantity: json['quantity'] ?? 1,
      category: json['category'] as String,
    );
  }

  // Convert Product instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'img': img,
      'price': price,
      'price-tagline': priceTagline,
      'tags': tags,
      'quantity': quantity,
      'category': category,
    };
  }
}

class GroceryData {
  final List<Product> english;
  final List<Product> hindi;
  final List<Product> gujarati;

  GroceryData({
    required this.english,
    required this.hindi,
    required this.gujarati,
  });

  // Factory constructor to create GroceryData from JSON
  factory GroceryData.fromJson(Map<String, dynamic> json) {
    return GroceryData(
      english:
          (json['english'] as List)
              .map((item) => Product.fromJson(item))
              .toList(),
      hindi:
          (json['hindi'] as List)
              .map((item) => Product.fromJson(item))
              .toList(),
      gujarati:
          (json['gujrati'] as List)
              .map((item) => Product.fromJson(item))
              .toList(),
    );
  }

  // Method to convert GroceryData to JSON
  Map<String, dynamic> toJson() {
    return {
      'english': english.map((product) => product.toJson()).toList(),
      'hindi': hindi.map((product) => product.toJson()).toList(),
      'gujrati': gujarati.map((product) => product.toJson()).toList(),
    };
  }
}
