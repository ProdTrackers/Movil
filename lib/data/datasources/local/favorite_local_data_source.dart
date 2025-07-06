import 'package:shared_preferences/shared_preferences.dart';

abstract class FavoriteLocalDataSource {
  Future<List<String>> getFavoriteItemIds();
  Future<void> addFavoriteItemId(String itemId);
  Future<void> removeFavoriteItemId(String itemId);
  Future<bool> isItemFavorite(String itemId);
}

const String CACHED_FAVORITE_ITEMS = 'CACHED_FAVORITE_ITEMS';

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  final SharedPreferences sharedPreferences;

  FavoriteLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> addFavoriteItemId(String itemId) async {
    final List<String> favoriteIds = await getFavoriteItemIds();
    if (!favoriteIds.contains(itemId)) {
      favoriteIds.add(itemId);
      await sharedPreferences.setStringList(CACHED_FAVORITE_ITEMS, favoriteIds);
    }
  }

  @override
  Future<List<String>> getFavoriteItemIds() async {
    final jsonStringList = sharedPreferences.getStringList(CACHED_FAVORITE_ITEMS);
    if (jsonStringList != null) {
      return Future.value(jsonStringList);
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<void> removeFavoriteItemId(String itemId) async {
    final List<String> favoriteIds = await getFavoriteItemIds();
    if (favoriteIds.contains(itemId)) {
      favoriteIds.remove(itemId);
      await sharedPreferences.setStringList(CACHED_FAVORITE_ITEMS, favoriteIds);
    }
  }

  @override
  Future<bool> isItemFavorite(String itemId) async {
    final List<String> favoriteIds = await getFavoriteItemIds();
    return favoriteIds.contains(itemId);
  }
}
