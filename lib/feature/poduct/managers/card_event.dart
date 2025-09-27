import 'package:equatable/equatable.dart';
import '../../../data/models/product_card_model.dart';

//commit: Barcha Cart eventlarini umumiy abstract class orqali aniqlash
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

//commit: Savatni yuklash eventi
class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

//commit: Savatga mahsulot qo‘shish eventi
class AddProductEvent extends CartEvent {
  final Product product;
  final int quantity;

  const AddProductEvent(this.product, {this.quantity = 1});

  @override
  List<Object?> get props => [product, quantity];
}

//commit: Savatdan mahsulotni o‘chirish eventi
class RemoveProductEvent extends CartEvent {
  final Product product;

  const RemoveProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

//commit: Mahsulot miqdorini yangilash eventi
class UpdateQuantityEvent extends CartEvent {
  final Product product;
  final int quantity;

  const UpdateQuantityEvent(this.product, this.quantity);

  @override
  List<Object?> get props => [product, quantity];
}

//commit: Savatni tozalash eventi
class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

//commit: Checkout (buyurtma berish) eventi
class CheckoutEvent extends CartEvent {
  const CheckoutEvent();
}

//commit: Legacy eventlar (orqaga moslik uchun)
//Mahsulot miqdorini o‘zgartirish legacy versiyasi
class ChangeQuantityEvent extends UpdateQuantityEvent {
  const ChangeQuantityEvent(Product product, int quantity) 
      : super(product, quantity);
}

//commit: Mahsulot qo‘shish legacy versiyasi
class AddToCartEvent extends AddProductEvent {
  const AddToCartEvent(Product product, {int quantity = 1}) 
      : super(product, quantity: quantity);
}

//commit: Mahsulotni o‘chirish legacy versiyasi
class RemoveFromCartEvent extends RemoveProductEvent {
  const RemoveFromCartEvent(Product product) : super(product);
}
