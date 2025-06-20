import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lockitem_movil/domain/entities/store_entity.dart';
import 'package:lockitem_movil/domain/usecases/get_all_stores.dart';
import 'package:lockitem_movil/core/error/failures.dart';


part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final GetAllStores getAllStores;

  StoreBloc({required this.getAllStores}) : super(StoreInitial()) {
    on<FetchAllStores>(_onFetchAllStores);
  }

  Future<void> _onFetchAllStores(
      FetchAllStores event,
      Emitter<StoreState> emit,
      ) async {
    emit(StoreLoading());
    final failureOrStores = await getAllStores();
    failureOrStores.fold(
          (failure) {
        if (failure is ServerFailure) {
          emit(StoreError(failure.message));
        } else if (failure is NetworkFailure) {
          emit(StoreError(failure.message));
        } else {
          emit(const StoreError('Ocurrió un error inesperado al cargar las tiendas.'));
        }
      },
          (stores) => emit(StoreLoaded(stores)),
    );
  }
}