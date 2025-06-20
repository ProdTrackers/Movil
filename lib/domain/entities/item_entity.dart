import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final String id;
  final String name;
  final String? color;
  final String? size;
  final String? imageUrl;
  final double? price;
  final String storeId;

  const ItemEntity({
    required this.id,
    required this.name,
    this.color,
    this.size,
    this.imageUrl,
    this.price,
    required this.storeId,
  });

  @override
  List<Object?> get props => [id, name, color, size, imageUrl, price, storeId];
}