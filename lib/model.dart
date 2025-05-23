// Model for representing a product in different languages
class Product {
  final int id;
  final String name;
  final String description;
  final String img;
  final double price;
  final String priceTagline;
  final List<String> tags;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.img,
    required this.price,
    required this.priceTagline,
    required this.tags,
  });

  // Factory constructor to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      img: json['img'] ?? '',
      price: json['price'].toDouble(),
      priceTagline: json['price-tagline'],
      tags: List<String>.from(json['tags']),
    );
  }

  // Method to convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'img': img,
      'price': price,
      'price-tagline': priceTagline,
      'tags': tags,
    };
  }
}

// Model to represent the entire grocery data with different language options
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
