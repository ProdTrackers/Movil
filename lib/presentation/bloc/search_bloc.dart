import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/usecases/get_all_items.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetAllItems getAllItemsUseCase;
  List<ItemEntity> _masterItemList = []; // Almacena la lista completa de ítems

  SearchBloc({required this.getAllItemsUseCase}) : super(SearchInitial()) {
    on<LoadAllItemsForSearch>(_onLoadAllItemsForSearch);
    on<SearchTermChanged>(
      _onSearchTermChanged
    );
  }

  Future<void> _onLoadAllItemsForSearch(
      LoadAllItemsForSearch event,
      Emitter<SearchState> emit,
      ) async {
    emit(SearchLoading());
    final failureOrItems = await getAllItemsUseCase();
    failureOrItems.fold(
          (failure) {
        emit(SearchError(_mapFailureToMessage(failure)));
      },
          (items) {
        _masterItemList = items;
        emit(SearchReady(allItems: items, filteredItems: items, currentSearchTerm: ""));
      },
    );
  }

  void _onSearchTermChanged(
      SearchTermChanged event,
      Emitter<SearchState> emit,
      ) {
    final searchTerm = event.searchTerm.toLowerCase();

    if (searchTerm.isEmpty) {
      emit(SearchReady(
        allItems: _masterItemList,
        filteredItems: _masterItemList,
        currentSearchTerm: searchTerm,
      ));
      return;
    }

    final filtered = _masterItemList.where((item) {
      return item.name.toLowerCase().contains(searchTerm);
    }).toList();

    emit(SearchReady(
      allItems: _masterItemList,
      filteredItems: filtered,
      currentSearchTerm: searchTerm,
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message ?? 'Error del servidor.';
    } else if (failure is NetworkFailure) {
      return failure.message ?? 'Error de red.';
    }
    return 'Ocurrió un error inesperado.';
  }
}