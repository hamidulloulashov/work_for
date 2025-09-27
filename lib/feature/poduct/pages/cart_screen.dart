import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:work_for/feature/common/widgets/global_appbar.dart';
import 'package:work_for/feature/poduct/managers/card_bloc.dart' show CartBloc;
import 'package:work_for/feature/poduct/managers/card_event.dart' show UpdateQuantityEvent, RemoveProductEvent, CheckoutEvent;
import 'package:work_for/feature/poduct/managers/card_state.dart' show CartState, CartLoaded, CartOperationSuccess, CartError, CheckoutSuccess, CartLoading;
import 'package:work_for/feature/poduct/widgets/card_helpr.dart' show CartHelpers;
import 'package:work_for/feature/poduct/widgets/card_item_widget.dart' show CartItemWidget;
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,

      // GlobalAppBar dan foydalanish
      appBar: GlobalAppBar(
        title: 'Shopping Cart',
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          // Clear Cart tugmasi
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final canClear = (state is CartLoaded && state.isNotEmpty) ||
                  (state is CartOperationSuccess && state.items.isNotEmpty);

              return IconButton(
                onPressed: canClear
                    ? () => CartHelpers.showClearCartDialog(context)
                    : null,
                icon: Icon(
                  Icons.delete_sweep,
                  color: canClear
                      ? theme.colorScheme.error
                      : theme.colorScheme.outline,
                ),
                tooltip: 'Clear Cart',
              );
            },
          ),
        ],
      ),

      //Body – BlocListener va BlocBuilder orqali savat holatini boshqarish
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            //Checkout muvaffaqiyatli bo'lsa dialog ko'rsatish
            CartHelpers.showCheckoutSuccessDialog(context, state);
          }
        },

        //Cart itemlarini va checkout footerini ko'rsatish
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              //Savat yuklanayotgan payt loader ko'rsatish
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading cart...',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            final items = CartHelpers.getItems(state);
            final total = CartHelpers.getTotal(state);
            final itemCount = CartHelpers.getItemCount(state);

            if (items.isEmpty) {
              //Savat bo'sh bo'lsa widget ko'rsatish
              return CartHelpers.emptyCartWidget(context, theme);
            }

            return Column(
              children: [
                //Cart items – mahsulotlar ro'yxatini ko'rsatish
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CartItemWidget(
                        item: item,
                        onQuantityChanged: (quantity) {
                          //Mahsulot miqdorini o'zgartirish
                          context.read<CartBloc>().add(
                                UpdateQuantityEvent(item.product, quantity),
                              );
                        },
                        onRemove: () {
                          //Mahsulotni savatdan olib tashlash
                          context.read<CartBloc>().add(
                                RemoveProductEvent(item.product),
                              );
                        },
                      );
                    },
                  ),
                ),

                //Checkout footer – umumiy summa va checkout tugmasi
                Container(
                  padding: EdgeInsets.all(isTablet ? 24 : 20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                            ),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Chap tomon ma'lumotlari
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Total Amount',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // O'ng tomon narxi
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.45,
                                    minWidth: 100,
                                  ),
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '\$${total.toStringAsFixed(2)}',
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Checkout tugmasi 
                        InkWell(
                          onTap: items.isNotEmpty
                              ? () {
                                  //Checkout tugmasini bosish
                                  context
                                      .read<CartBloc>()
                                      .add(const CheckoutEvent());
                                }
                              : null,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            height: 56.h,
                            decoration: BoxDecoration(
                              gradient: items.isNotEmpty
                                  ? LinearGradient(
                                      colors: [
                                        theme.colorScheme.primary,
                                        theme.colorScheme.primary.withOpacity(0.8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : LinearGradient(
                                      colors: [
                                        theme.colorScheme.outline.withOpacity(0.3),
                                        theme.colorScheme.outline.withOpacity(0.2),
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: items.isNotEmpty
                                  ? [
                                      BoxShadow(
                                        color: theme.colorScheme.primary.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.shopping_bag,
                                      size: 24,
                                      color: items.isNotEmpty
                                          ? Colors.white
                                          : theme.colorScheme.outline,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Proceed to Checkout',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: items.isNotEmpty
                                            ? Colors.white
                                            : theme.colorScheme.outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}