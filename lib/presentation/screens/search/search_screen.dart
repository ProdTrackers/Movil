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


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ItemEntity> _searchResults = [];
  bool _isLoading = false;


  List<ItemEntity> _allItems = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false; // Detener carga si la consulta está vacía
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });


    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return; // Verificar si el widget sigue montado

      // Filtrado SOLO por item.name
      final filteredItems = _allItems.where((item) {
        final itemName = item.name.toLowerCase();
        return itemName.contains(query);
      }).toList();

      setState(() {
        _searchResults = filteredItems;
        _isLoading = false;
      });
    });
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
                    // _onSearchChanged(); // Se llamará automáticamente por el listener
                  },
                )
                    : null,
              ),

            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_searchController.text.isNotEmpty && _searchResults.isEmpty && !_isLoading)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_outlined, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron productos con el nombre "${_searchController.text}"',
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (_searchController.text.isEmpty)
              Expanded(
                child: Center(
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
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final item = _searchResults[index];
                    return ListTile(
                      leading: item.imageUrl != null && item.imageUrl!.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          item.imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(width: 50, height: 50, color: Colors.grey[200], child: const Icon(Icons.broken_image, color: Colors.grey)),
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
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
                        ),
                      )
                          : Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)), child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 30)),
                      title: Text(item.name, style: textTheme.titleMedium),
                      subtitle: Text(
                        item.price != null ? '\$${item.price!.toStringAsFixed(2)}' : 'Precio no disponible',
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
                      ),
                      onTap: () {
                        // TODO: Implementar navegación a ProductDetailsScreen
                        // Ejemplo:
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ProductDetailsScreen(item: item),
                        //   ),
                        // );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Navegar a detalles de: ${item.name} (ID: ${item.id})'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}