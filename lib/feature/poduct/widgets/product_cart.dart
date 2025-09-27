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
            // Mahsulot rasmi
            SizedBox(
              height: 120.h,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[100],
                    child: const Center(
                      child: Icon(Icons.image_not_supported_outlined, size: 48),
                    ),
                  ),
                ),
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
                      height: 36, // 2 qator uchun belgilangan balandlik
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
                      child: product.category != null && product.category!.isNotEmpty
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.1),
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
                          
                          // Add to Cart Button - Fixed size
                          Container(
                            width: 85,
                            height: 36,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: onAddToCart,
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    // Main button content
                                    Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            isInCart ? Icons.add_shopping_cart : Icons.shopping_cart_outlined,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            isInCart ? 'Add' : 'Cart',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Quantity badge - positioned absolutely
                                    if (cartQuantity > 0)
                                      Positioned(
                                        right: -2,
                                        top: -2,
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          padding: const EdgeInsets.symmetric(horizontal: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius: BorderRadius.circular(9),
                                            border: Border.all(color: Colors.white, width: 1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$cartQuantity',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
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