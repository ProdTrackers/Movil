import 'package:lockitem_movil/domain/entities/item_entity.dart';

class ItemModel extends ItemEntity {
  const ItemModel({
    required String id,
    required String name,
    String? color,
    String? size,
    String? imageUrl,
    double? price,
    required String storeId,
  }) : super(
    id: id,
    name: name,
    color: color,
    size: size,
    imageUrl: imageUrl,
    price: price,
    storeId: storeId,
  );

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'].toString(),
      name: json['name'],
      color: json['color'],
      size: json['size'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num?)?.toDouble(),
      storeId: json['storeId'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'size': size,
      'imageUrl': imageUrl,
      'price': price,
      'storeId': int.tryParse(storeId),
    };
  }
}