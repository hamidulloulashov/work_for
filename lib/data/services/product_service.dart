import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_card_model.dart';

// commit: ProductService – mahsulotlarni yuklash, qidirish va kategoriyaga ko'ra ajratish
class ProductService {
  static const String _productsPath = 'assets/products.json';
  List<Product>? _cachedProducts;

  // commit: Mahsulotlarni JSON fayldan yoki cache dan yuklash
  Future<List<Product>> loadProducts() async {
    if (_cachedProducts != null) {
      return _cachedProducts!;
    }

    try {
      final jsonString = await rootBundle.loadString(_productsPath);
      final List<dynamic> jsonData = json.decode(jsonString);
      
      _cachedProducts = jsonData
          .map((productJson) => Product.fromJson(productJson))
          .toList();
      
      return _cachedProducts!;
    } catch (e) {
      print('Error loading products: $e');
      // commit: Xatolik bo'lsa mock mahsulotlarni qaytarish
      return _getMockProducts();
    }
  }

  // commit: ID bo'yicha mahsulotni olish
  Future<Product?> getProductById(int id) async {
    final products = await loadProducts();
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // commit: Mahsulotlarni qidirish
  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return await loadProducts();
    
    final products = await loadProducts();
    final searchQuery = query.toLowerCase();
    
    return products.where((product) {
      return product.name.toLowerCase().contains(searchQuery) ||
             (product.description?.toLowerCase().contains(searchQuery) ?? false) ||
             (product.category?.toLowerCase().contains(searchQuery) ?? false);
    }).toList();
  }

  // commit: Kategoriyaga ko'ra mahsulotlarni olish
  Future<List<Product>> getProductsByCategory(String? category) async {
    if (category == null || category.isEmpty) {
      return await loadProducts();
    }
    
    final products = await loadProducts();
    return products.where((product) => product.category == category).toList();
  }

  // commit: Barcha mavjud kategoriyalarni olish
  Future<List<String>> getCategories() async {
    final products = await loadProducts();
    final categories = products
        .map((product) => product.category)
        .where((category) => category != null)
        .cast<String>()
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  // commit: Xatolik bo'lsa mock mahsulotlarni yaratish
  List<Product> _getMockProducts() {
    return [
      Product(
        id: 1,
        name: "Apple iPhone 14",
        price: 999.99,
        image: "https://via.placeholder.com/300x200.png?text=iPhone+14",
        description: "Latest Apple iPhone with advanced features",
        category: "Electronics",
      ),
      Product(
        id: 2,
        name: "Samsung Galaxy S23",
        price: 899.50,
        image: "https://via.placeholder.com/300x200.png?text=Galaxy+S23",
        description: "Samsung's flagship smartphone",
        category: "Electronics",
      ),
      Product(
        id: 3,
        name: "Xiaomi Redmi Note 12",
        price: 249.00,
        image: "https://via.placeholder.com/300x200.png?text=Redmi+Note+12",
        description: "Affordable smartphone with great value",
        category: "Electronics",
      ),
    ];
  }

  // commit: Cache ni tozalash
  void clearCache() {
    _cachedProducts = null;
  }
}
