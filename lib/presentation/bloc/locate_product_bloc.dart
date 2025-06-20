import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lockitem_movil/domain/entities/iot_device_entity.dart';
import 'package:lockitem_movil/domain/usecases/get_iot_device_for_item.dart';
import 'package:lockitem_movil/core/error/failures.dart';

part 'locate_product_event.dart';
part 'locate_product_state.dart';

class LocateProductBloc extends Bloc<LocateProductEvent, LocateProductState> {
  final GetIotDeviceForItem getIotDeviceForItem;

  LocateProductBloc({required this.getIotDeviceForItem}) : super(LocateProductInitial()) {
    on<FetchDeviceLocation>(_onFetchDeviceLocation);
  }

  Future<void> _onFetchDeviceLocation(
      FetchDeviceLocation event,
      Emitter<LocateProductState> emit,
      ) async {
    emit(LocateProductLoading());
    final failureOrDevice = await getIotDeviceForItem(event.inventoryId);

    failureOrDevice.fold(
          (failure) {
        final errorMessage = failure is ServerFailure ? failure.message : (failure is NetworkFailure ? failure.message : 'Error desconocido');
        emit(LocateProductError('Error al obtener ubicación: $errorMessage'));
      },
          (device) {
        if (device != null && device.latitude != null && device.longitude != null) {
          emit(LocateProductLoaded(device));
        } else {
          emit(const LocateProductLocationNotAvailable("Ubicación para este producto no disponible o dispositivo no encontrado."));
        }
      },
    );
  }
}