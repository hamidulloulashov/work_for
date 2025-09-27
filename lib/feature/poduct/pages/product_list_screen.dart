// lib/feature/poduct/pages/product_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_for/data/models/product_item.dart';
import 'package:work_for/data/repositories/card_repository.dart';
import 'package:work_for/feature/common/widgets/global_appbar.dart';
import 'package:work_for/feature/poduct/managers/card_bloc.dart';
import 'package:work_for/feature/poduct/managers/card_event.dart';
import 'package:work_for/feature/poduct/managers/card_state.dart';
import 'package:work_for/feature/poduct/pages/card_screen.dart' hide GlobalAppBar;
import 'package:work_for/feature/poduct/widgets/card_helpr.dart' show CartHelpers;
import 'package:work_for/feature/poduct/widgets/product_cart.dart' show ProductCard;
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CartRepository>(
      future: _initRepository(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final cartRepository = snapshot.data!;
        return BlocProvider(
          create: (_) => CartBloc(cartRepository)..add(const LoadCartEvent()),
          child: const _ProductListView(),
        );
      },
    );
  }

  Future<CartRepository> _initRepository() async {
    final repo = CartRepository();
    await repo.init();
    return repo;
  }
}

class _ProductListView extends StatelessWidget {
  const _ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartBloc = context.read<CartBloc>();
    final products = cartBloc.repository.products;
    final theme = Theme.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final crossAxisCount = screenWidth < 600 ? 2 : (screenWidth < 900 ? 3 : 4);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: GlobalAppBar(
        title: 'Products',
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final itemCount = CartHelpers.getItemCount(state);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: cartBloc,
                              child: const CartScreen(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_outlined, size: 28),
                    ),
                    if (itemCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                          child: Center(
                            child: Text(
                              itemCount > 99 ? '99+' : '$itemCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          
          Expanded(
            child: products.isEmpty
                ? CartHelpers.emptyCartWidget(context, theme)
                : RefreshIndicator(
                    onRefresh: () async {
                      cartBloc.add(const LoadCartEvent());
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 150),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.60,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            final items = CartHelpers.getItems(state);
                            final cartItem = items.cast<CartItem?>().firstWhere(
                              (item) => item?.product.id == product.id,
                              orElse: () => null,
                            );
                            final isInCart = cartItem != null;
                            final cartQuantity = cartItem?.quantity ?? 0;

                            return ProductCard(
                              product: product,
                              isInCart: isInCart,
                              cartQuantity: cartQuantity,
                              onAddToCart: () {
                                cartBloc.add(AddProductEvent(product));
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final itemCount = CartHelpers.getItemCount(state);
          if (itemCount == 0) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: cartBloc,
                    child: const CartScreen(),
                  ),
                ),
              );
            },
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.shopping_cart),
            label: Text('Cart ($itemCount)'),
          );
        },
      ),
    );
  }
}
