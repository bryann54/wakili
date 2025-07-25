// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_generative_ai/google_generative_ai.dart' as _i656;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:uuid/uuid.dart' as _i706;

import '../../features/account/data/datasources/account_remote_datasource.dart'
    as _i302;
import '../../features/account/data/repositories/account_repository_impl.dart'
    as _i857;
import '../../features/account/domain/repositories/account_repository.dart'
    as _i1067;
import '../../features/account/domain/usecases/update_user_profile_usecase.dart'
    as _i475;
import '../../features/account/presentation/bloc/account_bloc.dart' as _i708;
import '../../features/auth/data/datasources/auth_remoteDataSource.dart'
    as _i167;
import '../../features/auth/data/repositories/auth_repositoryImpl.dart'
    as _i877;
import '../../features/auth/domain/repositories/auth_epository.dart' as _i626;
import '../../features/auth/domain/usecases/auth_usecases.dart' as _i46;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/bills/data/repositories/legal_document_repository_impl.dart'
    as _i515;
import '../../features/bills/domain/repositories/legal_document_repository.dart'
    as _i524;
import '../../features/bills/presentation/bloc/overview_bloc.dart' as _i1033;
import '../../features/chat_history/data/datasources/chat_history_remote_datasource.dart'
    as _i191;
import '../../features/chat_history/data/repositories/chat_history_repository_impl.dart'
    as _i914;
import '../../features/chat_history/domain/repositories/chat_history_repository.dart'
    as _i371;
import '../../features/chat_history/domain/usecases/delete_conversation_usecase.dart'
    as _i272;
import '../../features/chat_history/domain/usecases/generate_chat_title_usecase.dart'
    as _i701;
import '../../features/chat_history/domain/usecases/get_conversation_by_id_usecase.dart'
    as _i343;
import '../../features/chat_history/domain/usecases/get_conversations_usecase.dart'
    as _i375;
import '../../features/chat_history/domain/usecases/save_conversation_usecase.dart'
    as _i866;
import '../../features/chat_history/presentation/bloc/chat_history_bloc.dart'
    as _i393;
import '../../features/wakili/data/datasources/legal_category_remote_datasource.dart'
    as _i116;
import '../../features/wakili/data/datasources/wakili_chat_remote_datasource.dart'
    as _i106;
import '../../features/wakili/data/repositories/legal_category_repository_impl.dart'
    as _i909;
import '../../features/wakili/data/repositories/wakili_chat_repository_impl.dart'
    as _i644;
import '../../features/wakili/domain/repositories/legal_category_repository.dart'
    as _i460;
import '../../features/wakili/domain/repositories/wakili_chat_repository.dart'
    as _i313;
import '../../features/wakili/domain/usecases/get_legal_categories_usecase.dart'
    as _i644;
import '../../features/wakili/domain/usecases/send_message_stream_usecase.dart'
    as _i536;
import '../../features/wakili/domain/usecases/send_message_usecase.dart'
    as _i872;
import '../../features/wakili/presentation/bloc/wakili_bloc.dart' as _i69;
import '../api_client/client/dio_client.dart' as _i758;
import '../api_client/client_provider.dart' as _i546;
import '../chat/wakili_chat_core.dart' as _i716;
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
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModules.firebaseAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => registerModules.googleSignIn);
    gh.lazySingleton<_i706.Uuid>(() => registerModules.uuid);
    gh.lazySingleton<_i457.FirebaseStorage>(
        () => registerModules.firebaseStorage);
    gh.lazySingleton<_i656.GenerativeModel>(
        () => wakiliChatModule.generativeModel);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => wakiliChatModule.firestore);
    gh.lazySingleton<_i716.ConversationManager>(
        () => wakiliChatModule.conversationManager);
    gh.lazySingleton<_i716.WakiliQueryProcessor>(
        () => _i716.WakiliQueryProcessor());
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
    gh.lazySingleton<_i167.AuthRemoteDataSource>(
        () => _i167.AuthRemoteDataSourceImpl(
              firebaseAuth: gh<_i59.FirebaseAuth>(),
              googleSignIn: gh<_i116.GoogleSignIn>(),
              firebaseStorage: gh<_i457.FirebaseStorage>(),
              uuid: gh<_i706.Uuid>(),
            ));
    gh.lazySingleton<_i524.LegalDocumentRepository>(
        () => _i515.LegalDocumentRepositoryImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i302.AccountRemoteDataSource>(
        () => _i302.AccountRemoteDataSourceImpl(
              firebaseAuth: gh<_i59.FirebaseAuth>(),
              firebaseStorage: gh<_i457.FirebaseStorage>(),
              firestore: gh<_i974.FirebaseFirestore>(),
              uuid: gh<_i706.Uuid>(),
            ));
    gh.factory<_i191.ChatHistoryRemoteDataSource>(
        () => _i191.ChatHistoryRemoteDataSource(gh<_i974.FirebaseFirestore>()));
    gh.factory<_i116.LegalCategoryRemoteDataSource>(() =>
        _i116.LegalCategoryRemoteDataSource(gh<_i974.FirebaseFirestore>()));
    gh.factory<_i106.WakiliChatRemoteDataSource>(
        () => _i106.WakiliChatRemoteDataSource(
              gh<_i656.GenerativeModel>(),
              gh<_i716.WakiliQueryProcessor>(),
            ));
    gh.lazySingleton<_i460.LegalCategoryRepository>(() =>
        _i909.LegalCategoryRepositoryImpl(
            gh<_i116.LegalCategoryRemoteDataSource>()));
    gh.lazySingleton<_i361.Dio>(
        () => registerModules.dio(gh<String>(instanceName: 'BaseUrl')));
    gh.lazySingleton<_i1067.AccountRepository>(() =>
        _i857.AccountRepositoryImpl(
            remoteDataSource: gh<_i302.AccountRemoteDataSource>()));
    gh.lazySingleton<_i371.ChatHistoryRepository>(() =>
        _i914.ChatHistoryRepositoryImpl(
            gh<_i191.ChatHistoryRemoteDataSource>()));
    gh.lazySingleton<_i626.AuthRepository>(() => _i877.AuthRepositoryImpl(
        remoteDataSource: gh<_i167.AuthRemoteDataSource>()));
    gh.factory<_i1033.OverviewBloc>(
        () => _i1033.OverviewBloc(gh<_i524.LegalDocumentRepository>()));
    gh.lazySingleton<_i313.WakiliChatRepository>(() =>
        _i644.WakiliChatRepositoryImpl(gh<_i106.WakiliChatRemoteDataSource>()));
    gh.factory<_i701.GenerateChatTitleUseCase>(
        () => _i701.GenerateChatTitleUseCase(gh<_i313.WakiliChatRepository>()));
    gh.factory<_i536.SendMessageUseCase>(
        () => _i536.SendMessageUseCase(gh<_i313.WakiliChatRepository>()));
    gh.factory<_i872.SendMessageStreamUseCase>(
        () => _i872.SendMessageStreamUseCase(gh<_i313.WakiliChatRepository>()));
    gh.factory<_i644.GetLegalCategoriesUseCase>(() =>
        _i644.GetLegalCategoriesUseCase(gh<_i460.LegalCategoryRepository>()));
    gh.factory<_i475.UpdateUserProfileUseCase>(
        () => _i475.UpdateUserProfileUseCase(gh<_i1067.AccountRepository>()));
    gh.lazySingleton<_i758.DioClient>(() => _i758.DioClient(
          gh<_i361.Dio>(),
          gh<String>(instanceName: 'ApiKey'),
        ));
    gh.lazySingleton<_i46.SignInWithEmailAndPasswordUseCase>(() =>
        _i46.SignInWithEmailAndPasswordUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.SignUpWithEmailAndPasswordUseCase>(() =>
        _i46.SignUpWithEmailAndPasswordUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.SignInWithGoogleUseCase>(
        () => _i46.SignInWithGoogleUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.SignOutUseCase>(
        () => _i46.SignOutUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.GetAuthStateChangesUseCase>(
        () => _i46.GetAuthStateChangesUseCase(gh<_i626.AuthRepository>()));
    gh.lazySingleton<_i46.ResetPasswordUseCase>(
        () => _i46.ResetPasswordUseCase(gh<_i626.AuthRepository>()));
    gh.factory<_i708.AccountBloc>(() => _i708.AccountBloc(
        updateUserProfileUseCase: gh<_i475.UpdateUserProfileUseCase>()));
    gh.factory<_i375.GetConversationsUseCase>(
        () => _i375.GetConversationsUseCase(gh<_i371.ChatHistoryRepository>()));
    gh.factory<_i866.SaveConversationUseCase>(
        () => _i866.SaveConversationUseCase(gh<_i371.ChatHistoryRepository>()));
    gh.factory<_i343.GetConversationByIdUseCase>(() =>
        _i343.GetConversationByIdUseCase(gh<_i371.ChatHistoryRepository>()));
    gh.factory<_i272.DeleteConversationUseCase>(() =>
        _i272.DeleteConversationUseCase(gh<_i371.ChatHistoryRepository>()));
    gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
          signInWithEmailAndPasswordUseCase:
              gh<_i46.SignInWithEmailAndPasswordUseCase>(),
          signUpWithEmailAndPasswordUseCase:
              gh<_i46.SignUpWithEmailAndPasswordUseCase>(),
          signInWithGoogleUseCase: gh<_i46.SignInWithGoogleUseCase>(),
          signOutUseCase: gh<_i46.SignOutUseCase>(),
          getAuthStateChangesUseCase: gh<_i46.GetAuthStateChangesUseCase>(),
          resetPasswordUseCase: gh<_i46.ResetPasswordUseCase>(),
        ));
    gh.lazySingleton<_i546.ClientProvider>(
        () => _i546.ClientProvider(gh<_i758.DioClient>()));
    gh.factory<_i393.ChatHistoryBloc>(() => _i393.ChatHistoryBloc(
          gh<_i866.SaveConversationUseCase>(),
          gh<_i375.GetConversationsUseCase>(),
          gh<_i343.GetConversationByIdUseCase>(),
          gh<_i272.DeleteConversationUseCase>(),
          gh<_i701.GenerateChatTitleUseCase>(),
        ));
    gh.factory<_i69.WakiliBloc>(() => _i69.WakiliBloc(
          gh<_i536.SendMessageUseCase>(),
          gh<_i872.SendMessageStreamUseCase>(),
          gh<_i393.ChatHistoryBloc>(),
          gh<_i644.GetLegalCategoriesUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModules extends _i759.RegisterModules {}

class _$WakiliChatModule extends _i307.WakiliChatModule {}
