// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_generative_ai/google_generative_ai.dart' as _i656;
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
import '../../features/wakili/data/datasources/wakili_chat_remote_datasource.dart'
    as _i106;
import '../../features/wakili/data/repositories/wakili_chat_repository_impl.dart'
    as _i644;
import '../../features/wakili/domain/repositories/wakili_chat_repository.dart'
    as _i313;
import '../../features/wakili/domain/usecases/send_message_stream_usecase.dart'
    as _i536;
import '../../features/wakili/domain/usecases/send_message_usecase.dart'
    as _i872;
import '../../features/wakili/presentation/bloc/wakili_bloc.dart' as _i69;
import '../api_client/client/dio_client.dart' as _i758;
import '../api_client/client_provider.dart' as _i546;
import '../storage/storage_preference_manager.dart' as _i934;
import 'module_injector.dart' as _i759;
import 'wakili_chat_module.dart' as _i307;

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
    final wakiliChatModule = _$WakiliChatModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModules.prefs(),
      preResolve: true,
    );
    gh.lazySingleton<_i656.GenerativeModel>(
        () => wakiliChatModule.generativeModel);
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
    gh.lazySingleton<_i106.WakiliChatRemoteDataSource>(() =>
        _i106.GeminiWakiliChatRemoteDataSource(gh<_i656.GenerativeModel>()));
    gh.lazySingleton<_i29.AccountLocalDatasource>(() =>
        _i29.AccountLocalDatasource(gh<_i934.SharedPreferencesManager>()));
    gh.lazySingleton<_i1067.AccountRepository>(
        () => _i857.AccountRepositoryImpl(gh<_i29.AccountLocalDatasource>()));
    gh.lazySingleton<_i361.Dio>(
        () => registerModules.dio(gh<String>(instanceName: 'BaseUrl')));
    gh.lazySingleton<_i313.WakiliChatRepository>(() =>
        _i644.WakiliChatRepositoryImpl(gh<_i106.WakiliChatRemoteDataSource>()));
    gh.factory<_i536.SendMessageStreamUseCase>(
        () => _i536.SendMessageStreamUseCase(gh<_i313.WakiliChatRepository>()));
    gh.factory<_i872.SendMessageUseCase>(
        () => _i872.SendMessageUseCase(gh<_i313.WakiliChatRepository>()));
    gh.lazySingleton<_i993.ChangeLanguageUsecase>(
        () => _i993.ChangeLanguageUsecase(gh<_i1067.AccountRepository>()));
    gh.factory<_i69.WakiliBloc>(() => _i69.WakiliBloc(
          gh<_i872.SendMessageUseCase>(),
          gh<_i536.SendMessageStreamUseCase>(),
        ));
    gh.lazySingleton<_i758.DioClient>(() => _i758.DioClient(
          gh<_i361.Dio>(),
          gh<String>(instanceName: 'ApiKey'),
        ));
    gh.lazySingleton<_i546.ClientProvider>(
        () => _i546.ClientProvider(gh<_i758.DioClient>()));
    gh.factory<_i708.AccountBloc>(
        () => _i708.AccountBloc(gh<_i993.ChangeLanguageUsecase>()));
    return this;
  }
}

class _$RegisterModules extends _i759.RegisterModules {}

class _$WakiliChatModule extends _i307.WakiliChatModule {}
