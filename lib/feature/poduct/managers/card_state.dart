// lib/feature/cart/bloc/cart_state.dart
import 'package:equatable/equatable.dart';
import 'package:work_for/data/models/product_item.dart' show CartItem;

// commit: Asosiy CartState va loading, initial, error holatlari
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

// commit: Cart boshlang‘ich holati
class CartInitial extends CartState {
  const CartInitial();
}

// commit: Cart ma’lumotlari yuklanmoqda holati
class CartLoading extends CartState {
  const CartLoading();
}

// commit: Cart muvaffaqiyatli yuklangan holati
class CartLoaded extends CartState {
  final List<CartItem> items;
  final double total;
  final int itemCount;

  const CartLoaded({
    required this.items,
    required this.total,
    required this.itemCount,
  });

  CartLoaded copyWith({
    List<CartItem>? items,
    double? total,
    int? itemCount,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      total: total ?? this.total,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  @override
  List<Object?> get props => [items, total, itemCount];
}

// commit: Cart operatsiyasida xatolik yuz berdi
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

// commit: Cart operatsiyasi muvaffaqiyatli amalga oshdi (qo‘shish, o‘chirish, update)
class CartOperationSuccess extends CartState {
  final String message;
  final List<CartItem> items;
  final double total;
  final int itemCount;

  const CartOperationSuccess({
    required this.message,
    required this.items,
    required this.total,
    required this.itemCount,
  });

  @override
  List<Object?> get props => [message, items, total, itemCount];
}

// commit: Checkout muvaffaqiyatli amalga oshdi
class CheckoutSuccess extends CartState {
  final double totalAmount;
  final DateTime timestamp;

  const CheckoutSuccess({
    required this.totalAmount,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [totalAmount, timestamp];
}
