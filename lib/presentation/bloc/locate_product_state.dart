part of 'locate_product_bloc.dart';

abstract class LocateProductState extends Equatable {
  const LocateProductState();
  @override
  List<Object?> get props => [];
}

class LocateProductInitial extends LocateProductState {}
class LocateProductLoading extends LocateProductState {}
class LocateProductLoaded extends LocateProductState {
  final IotDeviceEntity iotDevice;
  const LocateProductLoaded(this.iotDevice);
  @override
  List<Object?> get props => [iotDevice];
}
class LocateProductLocationNotAvailable extends LocateProductState {
  final String message;
  const LocateProductLocationNotAvailable(this.message);
  @override
  List<Object?> get props => [message];
}
class LocateProductError extends LocateProductState {
  final String message;
  const LocateProductError(this.message);
  @override
  List<Object?> get props => [message];
}