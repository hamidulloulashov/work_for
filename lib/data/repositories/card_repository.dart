import 'package:work_for/data/models/product_item.dart' show CartItem;
import '../models/product_card_model.dart';
import '../services/local_storage.dart';
import '../services/product_service.dart';

// CartRepository – savatdagi mahsulotlarni boshqarish va saqlash uchun
class CartRepository {
  final LocalStorage _storage = LocalStorage();
  final ProductService _productService = ProductService();

  List<CartItem> _cartItems = [];
  List<Product> _products = [];
  bool _isInitialized = false;

  CartRepository();

  // Repository ni ishga tushirish va oldingi savatni yuklash
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      await _storage.init();
      _products = await _productService.loadProducts();
      await _loadCartFromStorage();
      _isInitialized = true;
    } catch (e) {
      print('Error initializing CartRepository: $e');
      _isInitialized = true; // cheksiz retry ni oldini olish
    }
  }

  // Saqlangan savat elementlarini local storage dan yuklash
  Future<void> _loadCartFromStorage() async {
    try {
      final savedItems = await _storage.loadCartItems();
      _cartItems = savedItems.map((itemJson) {
        final productId = itemJson['id'] as int;
        final product = _products.firstWhere(
          (p) => p.id == productId,
          orElse: () => throw Exception('Product not found: $productId'),
        );
        return CartItem.fromJson(itemJson, product);
      }).toList();
    } catch (e) {
      print('Error loading cart from storage: $e');
      _cartItems = [];
    }
  }

  // Savatni local storage ga saqlash
  Future<void> _saveCartToStorage() async {
    try {
      final itemsJson = _cartItems.map((item) => item.toJson()).toList();
      await _storage.saveCartItems(itemsJson);
    } catch (e) {
      print('Error saving cart to storage: $e');
    }
  }

  // Getterlar – mahsulotlar, savat, umumiy summa, item count
  List<Product> get products => List.unmodifiable(_products);
  List<CartItem> get cart => List.unmodifiable(_cartItems);
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get total => _cartItems.fold(0.0, (sum, item) => sum + item.total);
  bool get isEmpty => _cartItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty;

  // Savatga mahsulot qo‘shish
  Future<bool> addProduct(Product product, {int quantity = 1}) async {
    if (quantity <= 0) return false;

    try {
      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingIndex >= 0) {
        final existingItem = _cartItems[existingIndex];
        _cartItems[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
      } else {
        _cartItems.add(CartItem(product: product, quantity: quantity));
      }

      await _saveCartToStorage();
      return true;
    } catch (e) {
      print('Error adding product to cart: $e');
      return false;
    }
  }

  // Savatdan mahsulotni o‘chirish
  Future<bool> removeProduct(Product product) async {
    try {
      _cartItems.removeWhere((item) => item.product.id == product.id);
      await _saveCartToStorage();
      return true;
    } catch (e) {
      print('Error removing product from cart: $e');
      return false;
    }
  }

  // Mahsulot miqdorini yangilash
  Future<bool> updateQuantity(Product product, int quantity) async {
    if (quantity < 0) return false;

    try {
      if (quantity == 0) {
        return await removeProduct(product);
      }

      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingIndex >= 0) {
        _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: quantity,
        );
        await _saveCartToStorage();
        return true;
      }

      return false;
    } catch (e) {
      print('Error updating product quantity: $e');
      return false;
    }
  }

  // Savatni tozalash
  Future<bool> clearCart() async {
    try {
      _cartItems.clear();
      await _storage.clearCartItems();
      return true;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }

  // Savatdagi ma’lum mahsulotni olish
  CartItem? getCartItem(Product product) {
    try {
      return _cartItems.firstWhere(
        (item) => item.product.id == product.id,
      );
    } catch (e) {
      return null;
    }
  }

  // Mahsulot savatda bor-yo‘qligini tekshirish
  bool isProductInCart(Product product) {
    return _cartItems.any((item) => item.product.id == product.id);
  }

  // Mahsulot miqdorini olish
  int getProductQuantity(Product product) {
    final cartItem = getCartItem(product);
    return cartItem?.quantity ?? 0;
  }

  // Legacy methodlar – uchun
  void add(Product product) => addProduct(product);
  void remove(Product product) => removeProduct(product);
  void changeQty(Product product, int quantity) => updateQuantity(product, quantity);
  void clear() => clearCart();
}
