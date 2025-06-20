import 'package:flutter/material.dart';
import 'package:lockitem_movil/domain/entities/store_entity.dart';

class StoreListItem extends StatelessWidget {
  final StoreEntity store;

  const StoreListItem({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            store.name.isNotEmpty ? store.name[0].toUpperCase() : 'S',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
        title: Text(store.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          print('Tapped on store: ${store.name}');
          //Navigator.push(context, MaterialPageRoute(builder: (_) => CatalogScreen(store: store)));
        },
      ),
    );
  }
}