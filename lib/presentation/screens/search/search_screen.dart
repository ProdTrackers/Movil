import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockitem_movil/injection_container.dart' as di;

import '../../bloc/search_bloc.dart';
import '../home/product_details_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const String routeName = '/search';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SearchBloc>()..add(LoadAllItemsForSearch()),
      child: const _SearchScreenView(),
    );
  }
}

class _SearchScreenView extends StatefulWidget {
  const _SearchScreenView();

  @override
  State<_SearchScreenView> createState() => _SearchScreenViewState();
}

class _SearchScreenViewState extends State<_SearchScreenView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchQueryChanged);
  }

  void _onSearchQueryChanged() {
    // Dispara el evento al BLoC
    context.read<SearchBloc>().add(SearchTermChanged(_searchController.text));
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchQueryChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Productos por Nombre'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Escribe el nombre del producto...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    // _onSearchQueryChanged();
                  },
                )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is SearchReady) {
                  final itemsToShow = state.filteredItems;
                  final currentQuery = state.currentSearchTerm;

                  if (currentQuery.isEmpty && itemsToShow.isEmpty) {
                    return Center(
                        child: Text('No hay productos disponibles para buscar.', style: textTheme.titleMedium)
                    );
                  }

                  if (currentQuery.isNotEmpty && itemsToShow.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_outlined, size: 60, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No se encontraron productos con el nombre "$currentQuery"',
                              textAlign: TextAlign.center,
                              style: textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (currentQuery.isEmpty && itemsToShow.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.manage_search_rounded, size: 80, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Busca productos por su nombre',
                              style: textTheme.headlineSmall?.copyWith(color: Colors.grey[500]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Escribe en la barra para comenzar.',
                              style: textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }


                  return ListView.builder(
                    itemCount: itemsToShow.length,
                    itemBuilder: (context, index) {
                      final item = itemsToShow[index];
                      print('SearchScreen - Item: ${item.name}, Image URL: ${item.imageUrl}');

                      return ListTile(
                        leading: item.imageUrl != null && item.imageUrl!.isNotEmpty
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            item.imageUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child; // Imagen cargada
                              return Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[200],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              print('SearchScreen - Error cargando imagen ${item.imageUrl}: $exception');
                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(Icons.broken_image, color: Colors.grey, size: 30),
                              );
                            },
                          ),
                        )
                            : Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 30),
                        ),
                        title: Text(item.name, style: textTheme.titleMedium),
                        subtitle: Text(
                          item.price != null ? '\$${item.price!.toStringAsFixed(2)}' : 'Precio no disponible',
                          style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Navegar a detalles de: ${item.name} (ID: ${item.id})'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(item: item)));
                        },
                      );
                    },
                  );
                }
                return Center(
                    child: Text(
                      'Escribe para buscar productos...',
                      style: textTheme.headlineSmall?.copyWith(color: Colors.grey[500]),
                    )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}