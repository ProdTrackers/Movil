// ⚠️ ATENCIÓN: NO TOCAR, FUNCIONA Y NO SÉ PORQUE ⚠️
//
// Este fragmento de código fue escrito entre la 1 y las 4 de la mañana,
// bajo los efectos combinados de cafeína, desesperación y un bug que
// solo se manifiesta cuando nadie lo estaba mirando.
//
// No funciona si lo entiendes.
// No lo entiendes si funciona.
//
// Cualquier intento de refactorizar esto ha resultado en la invocación
// de problemas dimensionales, loops infinitos y un extraño parpadeo en el
// monitor que aún no puedo explicar.
//
// Si necesitas cambiar esto, primero reza, luego haz una copia de seguridad,
// y por último... suerte.

import 'package:flutter/material.dart';
import 'package:lockitem_movil/domain/entities/item_entity.dart';
import 'package:lockitem_movil/presentation/screens/home/locate_product_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ItemEntity item;

  const ProductDetailsScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  static const String routeName = '/item-details';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final bool itemHasImage = item.imageUrl != null && item.imageUrl!.isNotEmpty;
    final bool itemHasPrice = item.price != null && item.price! > 0;
    final String itemFormattedPrice = itemHasPrice
        ? '\$${item.price!.toStringAsFixed(2)}'
        : 'Consultar precio en tienda';

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: colorScheme.shadow,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Imagen del Ítem
            if (itemHasImage) // Usando la variable local
              Center(
                child: Image.network(
                  item.imageUrl!,
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
                    );
                  },
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                // ),
              )
            else
              Center(
                child: Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[500]),
                ),
              ),
            const SizedBox(height: 20),


            Text(
              item.name,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              itemFormattedPrice,
              style: textTheme.titleLarge?.copyWith(
                color: itemHasPrice ? colorScheme.primary : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),


            Row(
              children: [
                if (item.color != null && item.color!.isNotEmpty) ...[
                  Chip(
                    avatar: Icon(Icons.color_lens_outlined, size: 18, color: colorScheme.onPrimary),
                    label: Text(item.color!),
                    backgroundColor: colorScheme.shadow,
                    labelStyle: TextStyle(color: colorScheme.onPrimary),
                  ),
                  const SizedBox(width: 8),
                ],
                if (item.size != null && item.size!.isNotEmpty)
                  Chip(
                    avatar: Icon(Icons.straighten_outlined, size: 18, color: colorScheme.onPrimary),
                    label: Text(item.size!),
                    backgroundColor: colorScheme.shadow,
                    labelStyle: TextStyle(color: colorScheme.onPrimary),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Icon(Icons.storefront, color: Colors.grey[700], size: 18),
                const SizedBox(width: 8),
                Text(
                  'Disponible en tienda: ${item.storeId}',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.location_on_outlined, color: Colors.white),
                label: const Text('Localizar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.shadow,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: textTheme.titleMedium,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocateProductScreen(item: item), // Pasa el ítem actual
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}