part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object> get props => [];
}

class LoadFavoriteItems extends FavoriteEvent {}

class ToggleFavoriteStatus extends FavoriteEvent {
  final ItemEntity item;
  const ToggleFavoriteStatus(this.item);
  @override
  List<Object> get props => [item];
}


class CheckFavoriteStatus extends FavoriteEvent {
  final String itemId;
  const CheckFavoriteStatus(this.itemId);
  @override
  List<Object> get props => [itemId];
}