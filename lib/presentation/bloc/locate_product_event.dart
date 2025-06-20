part of 'locate_product_bloc.dart';

abstract class LocateProductEvent extends Equatable {
  const LocateProductEvent();
  @override
  List<Object> get props => [];
}

class FetchDeviceLocation extends LocateProductEvent {
  final String inventoryId;
  const FetchDeviceLocation(this.inventoryId);
  @override
  List<Object> get props => [inventoryId];
}