part of 'search_bloc.dart';


abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchReady extends SearchState {
  final List<ItemEntity> allItems;
  final List<ItemEntity> filteredItems;
  final String currentSearchTerm;

  const SearchReady({
    required this.allItems,
    required this.filteredItems,
    this.currentSearchTerm = "",
  });

  @override
  List<Object> get props => [allItems, filteredItems, currentSearchTerm];

  SearchReady copyWith({
    List<ItemEntity>? allItems,
    List<ItemEntity>? filteredItems,
    String? currentSearchTerm,
  }) {
    return SearchReady(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      currentSearchTerm: currentSearchTerm ?? this.currentSearchTerm,
    );
  }
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object> get props => [message];
}