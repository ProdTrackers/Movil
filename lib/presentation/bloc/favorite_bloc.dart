import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lockitem_movil/domain/entities/item_entity.dart';
import 'package:lockitem_movil/domain/usecases/add_favorite_item.dart';
import 'package:lockitem_movil/domain/usecases/get_favorite_items.dart';
import 'package:lockitem_movil/domain/usecases/is_item_favorite.dart';
import 'package:lockitem_movil/domain/usecases/remove_favorite_item.dart';
import 'package:lockitem_movil/core/error/failures.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoriteItems getFavoriteItems;
  final AddFavoriteItem addFavoriteItem;
  final RemoveFavoriteItem removeFavoriteItem;
  final IsItemFavorite isItemFavorite;

  FavoriteBloc({
    required this.getFavoriteItems,
    required this.addFavoriteItem,
    required this.removeFavoriteItem,
    required this.isItemFavorite,
  }) : super(FavoriteInitial()) {
    on<LoadFavoriteItems>(_onLoadFavoriteItems);
    on<ToggleFavoriteStatus>(_onToggleFavoriteStatus);
    on<CheckFavoriteStatus>(_onCheckFavoriteStatus);
  }

  Future<void> _onLoadFavoriteItems(
      LoadFavoriteItems event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    final failureOrFavorites = await getFavoriteItems();
    failureOrFavorites.fold(
            (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
            (items) {
          final Map<String, bool> statusMap = {};
          for (var item in items) {
            statusMap[item.id] = true;
          }
          emit(FavoriteLoaded(favoriteItems: items, itemFavoriteStatus: statusMap));
        }
    );
  }

  Future<void> _onToggleFavoriteStatus(
      ToggleFavoriteStatus event, Emitter<FavoriteState> emit) async {
    final currentState = state;
    Map<String, bool> currentStatusMap = {};
    List<ItemEntity> currentFavorites = [];

    if (currentState is FavoriteLoaded) {
      currentStatusMap = Map.from(currentState.itemFavoriteStatus);
      currentFavorites = List.from(currentState.favoriteItems);
    }

    final failureOrIsFavorite = await isItemFavorite(event.item.id);

    await failureOrIsFavorite.fold(
          (failure) {

        emit(FavoriteError(_mapFailureToMessage(failure)));

      },
          (isCurrentlyFavorite) async {
        if (isCurrentlyFavorite) {
          final failureOrSuccess = await removeFavoriteItem(event.item.id);
          failureOrSuccess.fold(
                (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
                (_) {
              currentStatusMap[event.item.id] = false;
              currentFavorites.removeWhere((item) => item.id == event.item.id);
              emit(FavoriteLoaded(favoriteItems: currentFavorites, itemFavoriteStatus: currentStatusMap));
            },
          );
        } else {
          final failureOrSuccess = await addFavoriteItem(event.item);
          failureOrSuccess.fold(
                (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
                (_) {
              currentStatusMap[event.item.id] = true;
              if (!currentFavorites.any((item) => item.id == event.item.id)) {
                currentFavorites.add(event.item);
              }
              emit(FavoriteLoaded(favoriteItems: currentFavorites, itemFavoriteStatus: currentStatusMap));
            },
          );
        }
      },
    );

    add(CheckFavoriteStatus(event.item.id));
  }

  Future<void> _onCheckFavoriteStatus(
      CheckFavoriteStatus event, Emitter<FavoriteState> emit) async {
    final failureOrIsFavorite = await isItemFavorite(event.itemId);
    failureOrIsFavorite.fold(
            (failure) {

          if (state is FavoriteLoaded) {
            final s = state as FavoriteLoaded;
            emit(s.copyWith(itemFavoriteStatus: Map.from(s.itemFavoriteStatus)..[event.itemId] = false ));
          }
        },
            (isFav) {
          if (state is FavoriteLoaded) {
            final s = state as FavoriteLoaded;
            emit(s.copyWith(itemFavoriteStatus: Map.from(s.itemFavoriteStatus)..[event.itemId] = isFav ));
          } else {
            emit(FavoriteLoaded(favoriteItems: const [], itemFavoriteStatus: {event.itemId: isFav}));
          }
        }
    );
  }


  String _mapFailureToMessage(Failure failure) {
    if (failure is CacheFailure) return failure.message ?? 'Error de Cache';
    return 'Error inesperado';
  }
}
