import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lockitem_movil/domain/entities/item_entity.dart';
import 'package:lockitem_movil/domain/usecases/get_items_by_store.dart';
import 'package:lockitem_movil/core/error/failures.dart';


part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetItemsByStore getItemsByStore;

  InventoryBloc({required this.getItemsByStore}) : super(InventoryInitial()) {
    on<FetchItemsByStore>(_onFetchItemsByStore);
  }

  Future<void> _onFetchItemsByStore(
      FetchItemsByStore event,
      Emitter<InventoryState> emit,
      ) async {
    emit(InventoryLoading());
    final failureOrItems = await getItemsByStore(event.storeId);
    failureOrItems.fold(
          (failure) {
        if (failure is ServerFailure) {
          emit(InventoryError(failure.message));
        } else if (failure is NetworkFailure) {
          emit(InventoryError(failure.message));
        } else {
          emit(const InventoryError('Ocurrió un error inesperado al cargar los artículos.'));
        }
      },
          (items) => emit(InventoryLoaded(items)),
    );
  }
}