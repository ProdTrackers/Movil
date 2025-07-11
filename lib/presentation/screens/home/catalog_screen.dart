import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockitem_movil/domain/entities/store_entity.dart';
import 'package:lockitem_movil/presentation/bloc/inventory_bloc.dart';
import 'package:lockitem_movil/presentation/screens/home/product_details_screen.dart';
import 'package:lockitem_movil/presentation/widgets/catalog_item_card.dart';
import 'package:lockitem_movil/injection_container.dart';

class CatalogScreen extends StatelessWidget {
  final StoreEntity store;

  const CatalogScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InventoryBloc>()..add(FetchItemsByStore(store.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(store.name),
          elevation: 1,
        ),
        body: BlocBuilder<InventoryBloc, InventoryState>(
          builder: (context, state) {
            if (state is InventoryLoading || state is InventoryInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InventoryLoaded) {
              if (state.items.isEmpty) {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.style_outlined, size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No hay artículos en el catálogo de ${store.name} por ahora.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    )
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<InventoryBloc>().add(FetchItemsByStore(store.id));
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(12.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(item: item),
                          ),
                        );
                      },
                      child: CatalogItemCard(item: item),
                    );
                  },
                ),
              );
            } else if (state is InventoryError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[400], size: 50),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                        onPressed: () {
                          context.read<InventoryBloc>().add(FetchItemsByStore(store.id));
                        },
                      )
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text('Estado no manejado'));
          },
        ),
      ),
    );
  }
}