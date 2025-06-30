// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/account/data/datasources/account_local_datasource.dart'
    as _i29;
import '../../features/account/data/repositories/account_repository_impl.dart'
    as _i857;
import '../../features/account/domain/repositories/account_repository.dart'
    as _i1067;
import '../../features/account/domain/usecases/change_language_usecase.dart'
    as _i993;
import '../../features/account/presentation/bloc/account_bloc.dart' as _i708;
import '../../features/favourites/data/datasources/favourites_local_datasource.dart'
    as _i458;
import '../../features/favourites/data/repositories/favourites_repository_impl.dart'
    as _i283;
import '../../features/favourites/domain/repositories/favourites_repository.dart'
    as _i518;
import '../../features/favourites/domain/usecases/add_to_favourites_usecase.dart'
    as _i21;
import '../../features/favourites/domain/usecases/check_if_fav_usecase.dart'
    as _i372;
import '../../features/favourites/domain/usecases/delete_favourite_usecase.dart'
    as _i506;
import '../../features/favourites/domain/usecases/load_favourites_usecase.dart'
    as _i926;
import '../../features/favourites/presentation/bloc/favourites_bloc.dart'
    as _i624;
import '../../features/hotels/data/datasources/hotels_remote_datasource.dart'
    as _i996;
import '../../features/hotels/data/repositories/hotels_repository_impl.dart'
    as _i224;
import '../../features/hotels/domain/repositories/hotels_repository.dart'
    as _i974;
import '../../features/hotels/domain/usecases/list_hotels_usecase.dart'
    as _i873;
import '../../features/hotels/presentation/bloc/hotels_bloc.dart' as _i179;
import '../api_client/client/dio_client.dart' as _i758;
import '../api_client/client_provider.dart' as _i546;
import '../storage/storage_preference_manager.dart' as _i934;
import 'module_injector.dart' as _i759;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModules = _$RegisterModules();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModules.prefs(),
      preResolve: true,
    );
    gh.factory<String>(
      () => registerModules.baseUrl,
      instanceName: 'BaseUrl',
    );
    gh.factory<String>(
      () => registerModules.apiKey,
      instanceName: 'ApiKey',
    );
    gh.lazySingleton<_i934.SharedPreferencesManager>(
        () => _i934.SharedPreferencesManager(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i458.FavouritesLocalDatasource>(() =>
        _i458.FavouritesLocalDatasource(gh<_i934.SharedPreferencesManager>()));
    gh.lazySingleton<_i29.AccountLocalDatasource>(() =>
        _i29.AccountLocalDatasource(gh<_i934.SharedPreferencesManager>()));
    gh.lazySingleton<_i361.Dio>(
        () => registerModules.dio(gh<String>(instanceName: 'BaseUrl')));
    gh.lazySingleton<_i1067.AccountRepository>(
        () => _i857.AccountRepositoryImpl(gh<_i29.AccountLocalDatasource>()));
    gh.lazySingleton<_i993.ChangeLanguageUsecase>(
        () => _i993.ChangeLanguageUsecase(gh<_i1067.AccountRepository>()));
    gh.lazySingleton<_i518.FavouritesRepository>(() =>
        _i283.FavouritesRepositoryImpl(gh<_i458.FavouritesLocalDatasource>()));
    gh.factory<_i708.AccountBloc>(
        () => _i708.AccountBloc(gh<_i993.ChangeLanguageUsecase>()));
    gh.lazySingleton<_i758.DioClient>(() => _i758.DioClient(
          gh<_i361.Dio>(),
          gh<String>(instanceName: 'ApiKey'),
        ));
    gh.lazySingleton<_i546.ClientProvider>(
        () => _i546.ClientProvider(gh<_i758.DioClient>()));
    gh.lazySingleton<_i372.CheckIfFavUsecase>(
        () => _i372.CheckIfFavUsecase(gh<_i518.FavouritesRepository>()));
    gh.lazySingleton<_i21.AddToFavouritesUsecase>(
        () => _i21.AddToFavouritesUsecase(gh<_i518.FavouritesRepository>()));
    gh.lazySingleton<_i506.DeleteFavouriteUsecase>(
        () => _i506.DeleteFavouriteUsecase(gh<_i518.FavouritesRepository>()));
    gh.lazySingleton<_i926.LoadFavouritesUsecase>(
        () => _i926.LoadFavouritesUsecase(gh<_i518.FavouritesRepository>()));
    gh.lazySingleton<_i996.HotelsRemoteDatasource>(
        () => _i996.HotelsRemoteDatasource(gh<_i546.ClientProvider>()));
    gh.factory<_i624.FavouritesBloc>(() => _i624.FavouritesBloc(
          gh<_i926.LoadFavouritesUsecase>(),
          gh<_i21.AddToFavouritesUsecase>(),
          gh<_i506.DeleteFavouriteUsecase>(),
          gh<_i372.CheckIfFavUsecase>(),
        ));
    gh.lazySingleton<_i974.HotelsRepository>(
        () => _i224.HotelsRepositoryImpl(gh<_i996.HotelsRemoteDatasource>()));
    gh.lazySingleton<_i873.ListHotelsUsecase>(
        () => _i873.ListHotelsUsecase(gh<_i974.HotelsRepository>()));
    gh.factory<_i179.HotelsBloc>(() => _i179.HotelsBloc(
          gh<_i873.ListHotelsUsecase>(),
          gh<_i934.SharedPreferencesManager>(),
        ));
    return this;
  }
}

class _$RegisterModules extends _i759.RegisterModules {}
