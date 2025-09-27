

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_for/data/models/product_item.dart' show CartItem;

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            // Yaxshilangan Product Image
            _buildProductImage(context, theme, isTablet),

            SizedBox(width: 12.w),

            // Product Info - Expanded to prevent overflow
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.product.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4.h),

                  if (item.product.category != null &&
                      item.product.category!.isNotEmpty)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        item.product.category!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),

                  SizedBox(height: 6.h),

                  // Price info - more compact
                  Row(
                    children: [
                      Text(
                        '\$${item.product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        ' × ${item.quantity}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    'Total: \$${item.total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Quantity Controls & Remove Button - Fixed width to prevent overflow
            SizedBox(
              width: 60.w,
              child: Column(
                children: [
                  _buildQuantityControls(context, theme),
                  SizedBox(height: 8.h),
                  _buildRemoveButton(context, theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(
      BuildContext context, ThemeData theme, bool isTablet) {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: const Color(0xFFFAFAFA),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: item.product.image.isNotEmpty
              ? Image.network(
                  item.product.image,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      _buildErrorWidget(theme),
                )
              : _buildErrorWidget(theme),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 20.sp,
            color: const Color(0xFF9E9E9E),
          ),
          SizedBox(height: 2.h),
          Text(
            'No Image',
            style: TextStyle(
              color: const Color(0xFFBDBDBD),
              fontSize: 8.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Increase
          InkWell(
            onTap: () => onQuantityChanged(item.quantity + 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              width: double.infinity,
              child: Icon(
                Icons.add,
                size: 16.sp,
                color: theme.colorScheme.primary,
              ),
            ),
          ),

          // Quantity Display
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
            ),
            child: Text(
              '${item.quantity}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Decrease
          InkWell(
            onTap: () {
              if (item.quantity > 1) onQuantityChanged(item.quantity - 1);
            },
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.r),
              bottomRight: Radius.circular(16.r),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              width: double.infinity,
              child: Icon(
                Icons.remove,
                size: 16.sp,
                color: item.quantity > 1
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveButton(BuildContext context, ThemeData theme) {
    return InkWell(
      onTap: onRemove,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(
          Icons.delete_outline,
          size: 18.sp,
          color: theme.colorScheme.error,
        ),
      ),
    );
  }
}
