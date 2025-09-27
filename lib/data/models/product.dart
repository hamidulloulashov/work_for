class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final String? description;
  final String? category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.description,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: (json['id'] as num).toInt(),
        name: json['name'] ?? '',
        price: (json['price'] as num).toDouble(),
        image: json['image'] ?? '',
        description: json['description'],
        category: json['category'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'image': image,
        'description': description,
        'category': category,
      };
}