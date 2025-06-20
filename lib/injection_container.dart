// ⚠️ ATENCIÓN: NO TOCAR, FUNCIONA Y NO SÉ PORQUE ⚠️
//
// Este fragmento de código fue escrito entre la 1 y las 4 de la mañana,
// bajo los efectos combinados de cafeína, desesperación y un bug que
// solo se manifiesta cuando nadie lo estaba mirando.
//
// No funciona si lo entiendes.
// No lo entiendes si funciona.
//
// Cualquier intento de refactorizar esto ha resultado en la invocación
// de problemas dimensionales, loops infinitos y un extraño parpadeo en el
// monitor que aún no puedo explicar.
//
// Si necesitas cambiar esto, primero reza, luego haz una copia de seguridad,
// y por último... suerte.

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
import 'package:lockitem_movil/presentation/bloc/locate_product_bloc.dart';
import 'package:lockitem_movil/presentation/bloc/store_bloc.dart';
import 'package:lockitem_movil/data/datasources/remote/inventory_remote_data_source.dart';
import 'package:lockitem_movil/data/repositories/inventory_repository_impl.dart';
import 'package:lockitem_movil/domain/repositories/inventory_repository.dart';
import 'package:lockitem_movil/domain/usecases/get_items_by_store.dart';
import 'package:lockitem_movil/presentation/bloc/inventory_bloc.dart';

import 'data/datasources/remote/iot_device_remote_data_source.dart';
import 'data/repositories/iot_device_repository_impl.dart';
import 'domain/repositories/iot_device_repository.dart';
import 'domain/usecases/get_iot_device_for_item.dart';


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

  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => SignupUser(sl()));
  sl.registerLazySingleton(() => GetAllStores(sl()));
  sl.registerLazySingleton(() => GetItemsByStore(sl()));
  sl.registerLazySingleton(() => GetIotDeviceForItem(sl()));


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


  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton(() => http.Client());
  }
  if (!sl.isRegistered<Connectivity>()) {
    sl.registerLazySingleton(() => Connectivity());
  }
}