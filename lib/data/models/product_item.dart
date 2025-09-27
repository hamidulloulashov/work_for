import 'product_card_model.dart';

// CartItem klassi – mahsulot va miqdorni saqlaydi, JSON serializatsiya qo‘llanadi
class CartItem {
  final Product product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  // JSON’dan CartItem yaratish
  factory CartItem.fromJson(Map<String, dynamic> json, Product product) {
    return CartItem(
      product: product,
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  // CartItem nusxasini yaratish, miqdor yoki mahsulotni o‘zgartirish imkoniyati
  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  // CartItem ni JSON formatga o‘tkazish
  Map<String, dynamic> toJson() => {
        'id': product.id,
        'quantity': quantity,
      };

  // Mahsulot umumiy summasi
  double get total => product.price * quantity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          product == other.product;

  @override
  int get hashCode => product.hashCode;
}
