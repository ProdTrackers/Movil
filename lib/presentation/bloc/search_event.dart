part of 'search_bloc.dart';


abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object> get props => [];
}

class LoadAllItemsForSearch extends SearchEvent {}

class SearchTermChanged extends SearchEvent {
  final String searchTerm;
  const SearchTermChanged(this.searchTerm);
  @override
  List<Object> get props => [searchTerm];
}