// presentation/widgets/catalog_item_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockitem_movil/domain/entities/item_entity.dart';

import '../bloc/favorite_bloc.dart';

class CatalogItemCard extends StatefulWidget {
  final ItemEntity item;
  const CatalogItemCard({super.key, required this.item});

  @override
  State<CatalogItemCard> createState() => _CatalogItemCardState();
}

class _CatalogItemCardState extends State<CatalogItemCard> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(CheckFavoriteStatus(widget.item.id));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: widget.item.imageUrl != null && widget.item.imageUrl!.isNotEmpty
                        ? Image.network(
                      widget.item.imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.broken_image, color: Colors.grey[400], size: 40),
                        );
                      },
                    )
                        : Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 40),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<FavoriteBloc, FavoriteState>(
                    buildWhen: (previous, current) {
                      if (current is FavoriteLoaded) {
                        bool? previousStatus = (previous is FavoriteLoaded) ? previous.itemFavoriteStatus[widget.item.id] : null;
                        return current.itemFavoriteStatus[widget.item.id] != previousStatus;
                      }
                      return current is FavoriteInitial && previous is! FavoriteLoaded;
                    },
                    builder: (context, state) {
                      bool isFav = false;
                      if (state is FavoriteLoaded) {
                        isFav = state.itemFavoriteStatus[widget.item.id] ?? false;
                      }

                      return GestureDetector(
                        onTap: () {
                          context.read<FavoriteBloc>().add(ToggleFavoriteStatus(widget.item));
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.3),
                          radius: 18,
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.redAccent : Colors.white,
                            size: 22,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (widget.item.size != null || widget.item.color != null)
                  Text(
                    '${widget.item.color ?? ''}${widget.item.color != null && widget.item.size != null ? ' - ' : ''}${widget.item.size ?? ''}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 6),
                Text(
                  widget.item.price != null ? '\$${widget.item.price!.toStringAsFixed(2)}' : 'Precio no disponible',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
