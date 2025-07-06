import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockitem_movil/presentation/widgets/catalog_item_card.dart';

import '../../bloc/favorite_bloc.dart';

class SaveScreen extends StatelessWidget {
  const SaveScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading || state is FavoriteInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            if (state.favoriteItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No tienes prendas guardadas',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Presiona el corazón en los productos para guardarlos aquí.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.75,
              ),
              itemCount: state.favoriteItems.length,
              itemBuilder: (context, index) {
                final item = state.favoriteItems[index];
                return CatalogItemCard(item: item);
              },
            );
          } else if (state is FavoriteError) {
            return Center(child: Text('Error al cargar favoritos: ${state.message}'));
          }
          return const Center(child: Text('Tus prendas favoritas aparecerán aquí.'));
        },
      ),
    );
  }
}
