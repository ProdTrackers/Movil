part of 'favorite_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();
  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<ItemEntity> favoriteItems;
  final Map<String, bool> itemFavoriteStatus;

  const FavoriteLoaded({required this.favoriteItems, this.itemFavoriteStatus = const {}});

  FavoriteLoaded copyWith({
    List<ItemEntity>? favoriteItems,
    Map<String, bool>? itemFavoriteStatus,
  }) {
    return FavoriteLoaded(
      favoriteItems: favoriteItems ?? this.favoriteItems,
      itemFavoriteStatus: itemFavoriteStatus ?? this.itemFavoriteStatus,
    );
  }

  @override
  List<Object> get props => [favoriteItems, itemFavoriteStatus];
}

class FavoriteError extends FavoriteState {
  final String message;
  const FavoriteError(this.message);
  @override
  List<Object> get props => [message];
}

class ItemFavoriteStatusLoaded extends FavoriteState {
  final bool isFavorite;
  final String itemId; // Para identificar qué ítem se actualizó
  const ItemFavoriteStatusLoaded(this.itemId, this.isFavorite);
  @override
  List<Object> get props => [itemId, isFavorite];
}
