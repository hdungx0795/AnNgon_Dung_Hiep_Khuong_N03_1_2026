import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/favorites_provider.dart';
import '../../../providers/product_provider.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final productProvider = context.watch<ProductProvider>();
    
    final favoriteProducts = productProvider.products
        .where((p) => favoritesProvider.isFavorite(p.id))
        .toList();

    if (favoriteProducts.isEmpty) {
      return const Center(child: Text('Chưa có sản phẩm yêu thích'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: favoriteProducts.length,
      itemBuilder: (context, index) {
        final product = favoriteProducts[index];
        return Card(
          child: Column(
            children: [
              Expanded(child: Image.asset(product.imagePath, fit: BoxFit.cover)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(product.name),
              ),
            ],
          ),
        );
      },
    );
  }
}
