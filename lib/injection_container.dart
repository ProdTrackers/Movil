import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lockitem_movil/core/platform/network_info.dart';
import 'package:lockitem_movil/data/datasources/remote/auth_remote_data_source.dart';
import 'package:lockitem_movil/data/repositories/auth_repository_impl.dart';
import 'package:lockitem_movil/domain/repositories/auth_repository.dart';
import 'package:lockitem_movil/domain/usecases/login_user.dart';
import 'package:lockitem_movil/domain/usecases/signup_user.dart';
import 'package:lockitem_movil/presentation/bloc/auth_bloc.dart';
import 'package:lockitem_movil/data/datasources/remote/store_remote_data_source.dart';
import 'package:lockitem_movil/data/repositories/store_repository_impl.dart';
import 'package:lockitem_movil/domain/repositories/store_repository.dart';
import 'package:lockitem_movil/domain/usecases/get_all_stores.dart';
import 'package:lockitem_movil/presentation/bloc/favorite_bloc.dart';
import 'package:lockitem_movil/presentation/bloc/locate_product_bloc.dart';
import 'package:lockitem_movil/presentation/bloc/search_bloc.dart';
import 'package:lockitem_movil/presentation/bloc/store_bloc.dart';
import 'package:lockitem_movil/data/datasources/remote/inventory_remote_data_source.dart';
import 'package:lockitem_movil/data/repositories/inventory_repository_impl.dart';
import 'package:lockitem_movil/domain/repositories/inventory_repository.dart';
import 'package:lockitem_movil/domain/usecases/get_items_by_store.dart';
import 'package:lockitem_movil/presentation/bloc/inventory_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/local/favorite_local_data_source.dart';
import 'data/datasources/remote/iot_device_remote_data_source.dart';
import 'data/repositories/favorite_repository_impl.dart';
import 'data/repositories/iot_device_repository_impl.dart';
import 'domain/repositories/favorite_repository.dart';
import 'domain/repositories/iot_device_repository.dart';
import 'domain/usecases/add_favorite_item.dart';
import 'domain/usecases/get_all_items.dart';
import 'domain/usecases/get_favorite_items.dart';
import 'domain/usecases/get_iot_device_for_item.dart';
import 'domain/usecases/is_item_favorite.dart';
import 'domain/usecases/remove_favorite_item.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(
        () => AuthBloc(
      loginUser: sl(),
      signupUser: sl(),
    ),
  );
  sl.registerFactory(
        () => StoreBloc(getAllStores: sl()),
  );
  sl.registerFactory(
        () => InventoryBloc(getItemsByStore: sl()),
  );
  sl.registerFactory(
        () => LocateProductBloc(getIotDeviceForItem: sl()),
  );
  sl.registerFactory(
        () => SearchBloc(getAllItemsUseCase: sl()),
  );
  sl.registerFactory(
        () => FavoriteBloc(
      getFavoriteItems: sl(),
      addFavoriteItem: sl(),
      removeFavoriteItem: sl(),
      isItemFavorite: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => SignupUser(sl()));
  sl.registerLazySingleton(() => GetAllStores(sl()));
  sl.registerLazySingleton(() => GetItemsByStore(sl()));
  sl.registerLazySingleton(() => GetIotDeviceForItem(sl()));
  sl.registerLazySingleton(() => GetAllItems(sl()));
  sl.registerLazySingleton(() => GetFavoriteItems(sl()));
  sl.registerLazySingleton(() => AddFavoriteItem(sl()));
  sl.registerLazySingleton(() => RemoveFavoriteItem(sl()));
  sl.registerLazySingleton(() => IsItemFavorite(sl()));


  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<StoreRepository>(
        () => StoreRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<InventoryRepository>(
        () => InventoryRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<IotDeviceRepository>(
        () => IotDeviceRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<FavoriteRepository>(
        () => FavoriteRepositoryImpl(
      localDataSource: sl(),
      inventoryRepository: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<StoreRemoteDataSource>(
        () => StoreRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<InventoryRemoteDataSource>(
        () => InventoryRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<IotDeviceRemoteDataSource>(
        () => IotDeviceRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<FavoriteLocalDataSource>(
        () => FavoriteLocalDataSourceImpl(sharedPreferences: sl()),
  );


  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton(() => http.Client());
  }
  if (!sl.isRegistered<Connectivity>()) {
    sl.registerLazySingleton(() => Connectivity());
  }
  if (!sl.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
  }
}