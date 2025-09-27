import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/product_card_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;
  final bool isInCart;
  final int cartQuantity;

  const ProductCard({
    super.key,
    required this.product,
    this.onAddToCart,
    this.onTap,
    this.isInCart = false,
    this.cartQuantity = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            

            Container(
              height: 140.h,
              margin: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.r)),
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.2,
                        colors: [Colors.white, Colors.grey[25] ?? Colors.white],
                      ),
                    ),
                  ),
                  // Rasm
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Center(
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Icon(Icons.smartphone_outlined,
                                  size: 28.sp, color: Colors.grey[400]),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'No Image Available',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Mahsulot ma'lumotlari
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mahsulot nomi - 2 qator uchun belgilangan balandlik
                    Container(
                      // height: 36, // 2 qator uchun belgilangan balandlik
                      alignment: Alignment.topLeft,
                      child: Text(
                        product.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                          fontSize: 16.sp,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Kategoriya - belgilangan balandlik
                    SizedBox(
                      height: 22,
                      child: product.category != null &&
                              product.category!.isNotEmpty
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  product.category!,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    const Spacer(), // Bu narx qismini pastga suradi

                    // Narx va Savatchaga qo'shish tugmasi - belgilangan balandlik
                    SizedBox(
                      height: 36,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Narx
                          Expanded(
                            flex: 2,
                            child: Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),

                          const SizedBox(width: 8),

                          
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: 85,
                            height: 36,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Tugma
                                Container(
                                  width: 85,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isInCart
                                        ? theme.colorScheme.primary
                                            .withOpacity(0.9)
                                        : theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: onAddToCart,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AnimatedSwitcher(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              child: Icon(
                                                isInCart
                                                    ? Icons.add_shopping_cart
                                                    : Icons
                                                        .shopping_cart_outlined,
                                                key: ValueKey(isInCart),
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            AnimatedSwitcher(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              child: Text(
                                                isInCart ? 'Add' : 'Cart',
                                                key: ValueKey(isInCart),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Animated badge
                                if (cartQuantity > 0)
                                  Positioned(
                                    right: -6,
                                    top: -6,
                                    child: AnimatedScale(
                                      scale: cartQuantity > 0 ? 1.0 : 0.0,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.elasticOut,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          minWidth: 22,
                                          minHeight: 22,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: cartQuantity > 9 ? 6 : 4,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.red.shade500,
                                              Colors.red.shade700
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.red.withOpacity(0.4),
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          cartQuantity > 99
                                              ? '99+'
                                              : '$cartQuantity',
                                          style: TextStyle(
                                            fontSize: cartQuantity > 9 ? 9 : 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            height: 1.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
