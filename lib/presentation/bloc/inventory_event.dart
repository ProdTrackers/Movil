part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

class FetchItemsByStore extends InventoryEvent {
  final String storeId;

  const FetchItemsByStore(this.storeId);

  @override
  List<Object> get props => [storeId];
}