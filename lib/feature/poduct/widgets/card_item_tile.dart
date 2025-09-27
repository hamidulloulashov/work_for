import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_for/data/models/product_item.dart' show CartItem;

//CartItemWidget – Savatdagi mahsulotni ko'rsatish, miqdor o'zgartirish va o'chirish tugmalari
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
          
Container(
  width: isTablet ? 120.w : MediaQuery.of(context).size.width * 0.25,
  height: isTablet ? 120.h : MediaQuery.of(context).size.width * 0.3,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12.r),
    color: Colors.grey[100],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12.r),
    child: Image.network(
      item.product.image,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            color: theme.colorScheme.primary,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[200],
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey[400],
            size: isTablet ? 40.sp : 32.sp,
          ),
        );
      },
    ),
  ),
),

            SizedBox(width: 16.w),

            //Product Info (Name, Category, Price, Total)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  if (item.product.category != null && item.product.category!.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        item.product.category!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        '\$${item.product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 10.sp,
                        ),
                      ),
                      Text(
                        ' × ${item.quantity}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 14.sp,
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
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            //Quantity Controls & Remove Button
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Decrease
                      InkWell(
                        onTap: () {
                          if (item.quantity > 1) onQuantityChanged(item.quantity - 1);
                        },
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          bottomLeft: Radius.circular(20.r),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.remove,
                            size: 20.sp,
                            color: item.quantity > 1
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                          ),
                        ),
                      ),
                      // Quantity Display
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        child: Text(
                          '${item.quantity}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      // Increase
                      InkWell(
                        onTap: () => onQuantityChanged(item.quantity + 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(Icons.add, size: 20.sp, color: theme.colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                // Remove
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(Icons.delete_outline, size: 20.sp, color: theme.colorScheme.error),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
