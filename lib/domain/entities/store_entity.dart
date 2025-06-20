import 'package:equatable/equatable.dart';

class StoreEntity extends Equatable {
  final String id;
  final String name;

  const StoreEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}