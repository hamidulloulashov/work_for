import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_for/data/repositories/card_repository.dart' show CartRepository;
import 'package:work_for/feature/poduct/managers/card_event.dart' show CartEvent, LoadCartEvent, AddProductEvent, RemoveProductEvent, UpdateQuantityEvent, ClearCartEvent, CheckoutEvent, ChangeQuantityEvent, AddToCartEvent, RemoveFromCartEvent;
import 'package:work_for/feature/poduct/managers/card_state.dart' show CartState, CartInitial, CartLoading, CartError, CartOperationSuccess, CartLoaded, CheckoutSuccess;

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc(this.repository) : super(const CartInitial()) {
    // Eventlar bilan bog'lash
    on<LoadCartEvent>(_onLoadCart);             // Savatni yuklash
    on<AddProductEvent>(_onAddProduct);         // Mahsulot qo‘shish
    on<RemoveProductEvent>(_onRemoveProduct);   // Mahsulotni o‘chirish
    on<UpdateQuantityEvent>(_onUpdateQuantity); // Mahsulot miqdorini yangilash
    on<ClearCartEvent>(_onClearCart);           // Savatni tozalash
    on<CheckoutEvent>(_onCheckout);             // Checkout qilish
    
    // Legacy eventlar bilan ham ishlash
    on<ChangeQuantityEvent>((event, emit) => _onUpdateQuantity(event, emit));
    on<AddToCartEvent>((event, emit) => _onAddProduct(event, emit));
    on<RemoveFromCartEvent>((event, emit) => _onRemoveProduct(event, emit));
  }

  // commit: Savatni yuklash
  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      await repository.init();
      final items = repository.cart;
      final total = repository.total;
      final itemCount = repository.itemCount;
      emit(CartLoaded(
        items: items,
        total: total,
        itemCount: itemCount,
      ));
    } catch (e) {
      emit(CartError('Savatni yuklashda xatolik: ${e.toString()}'));
    }
  }

  // commit: Mahsulot qo‘shish
  Future<void> _onAddProduct(AddProductEvent event, Emitter<CartState> emit) async {
    try {
      final success = await repository.addProduct(event.product, quantity: event.quantity);
      if (success) {
        final items = repository.cart;
        final total = repository.total;
        final itemCount = repository.itemCount;
        emit(CartOperationSuccess(
          message: '${event.product.name} savatga qo‘shildi',
          items: items,
          total: total,
          itemCount: itemCount,
        ));
      } else {
        emit(const CartError('Mahsulot savatga qo‘shilmadi'));
      }
    } catch (e) {
      emit(CartError('Mahsulot qo‘shishda xatolik: ${e.toString()}'));
    }
  }

  // commit: Mahsulotni o‘chirish
  Future<void> _onRemoveProduct(RemoveProductEvent event, Emitter<CartState> emit) async {
    try {
      final success = await repository.removeProduct(event.product);
      if (success) {
        final items = repository.cart;
        final total = repository.total;
        final itemCount = repository.itemCount;
        emit(CartOperationSuccess(
          message: '${event.product.name} savatdan o‘chirildi',
          items: items,
          total: total,
          itemCount: itemCount,
        ));
      } else {
        emit(const CartError('Mahsulot savatdan o‘chirilmadi'));
      }
    } catch (e) {
      emit(CartError('Mahsulotni o‘chirishda xatolik: ${e.toString()}'));
    }
  }

  // commit: Mahsulot miqdorini yangilash
  Future<void> _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) async {
    try {
      final success = await repository.updateQuantity(event.product, event.quantity);
      if (success) {
        final items = repository.cart;
        final total = repository.total;
        final itemCount = repository.itemCount;
        String message;
        if (event.quantity == 0) {
          message = '${event.product.name} savatdan o‘chirildi';
        } else {
          message = '${event.product.name} miqdori yangilandi';
        }
        emit(CartOperationSuccess(
          message: message,
          items: items,
          total: total,
          itemCount: itemCount,
        ));
      } else {
        emit(const CartError('Mahsulot miqdorini yangilash muvaffaqiyatsiz'));
      }
    } catch (e) {
      emit(CartError('Miqdor yangilashda xatolik: ${e.toString()}'));
    }
  }

  // commit: Savatni tozalash
  Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    try {
      final success = await repository.clearCart();
      if (success) {
        emit(const CartOperationSuccess(
          message: 'Savat muvaffaqiyatli tozalandi',
          items: [],
          total: 0.0,
          itemCount: 0,
        ));
      } else {
        emit(const CartError('Savatni tozalash muvaffaqiyatsiz'));
      }
    } catch (e) {
      emit(CartError('Savatni tozalashda xatolik: ${e.toString()}'));
    }
  }

  // commit: Checkout jarayoni
  Future<void> _onCheckout(CheckoutEvent event, Emitter<CartState> emit) async {
    try {
      final total = repository.total;
      if (total <= 0) {
        emit(const CartError('Savat bo‘sh'));
        return;
      }

      // Checkoutni simulyatsiya qilish
      await Future.delayed(const Duration(seconds: 1));
      
      final success = await repository.clearCart();
      if (success) {
        emit(CheckoutSuccess(
          totalAmount: total,
          timestamp: DateTime.now(),
        ));
      } else {
        emit(const CartError('Checkout muvaffaqiyatsiz'));
      }
    } catch (e) {
      emit(CartError('Checkoutda xatolik: ${e.toString()}'));
    }
  }
}
