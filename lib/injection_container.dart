import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:petadopt_prueba2_app/core/constants/app_constants.dart';

// Auth
import 'package:petadopt_prueba2_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:petadopt_prueba2_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:petadopt_prueba2_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:petadopt_prueba2_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:petadopt_prueba2_app/features/auth/presentation/cubit/auth_cubit.dart';

// Pets
import 'package:petadopt_prueba2_app/features/pets/data/datasources/pets_remote_datasource.dart';
import 'package:petadopt_prueba2_app/features/pets/data/repositories/pets_repository_impl.dart';
import 'package:petadopt_prueba2_app/features/pets/domain/usecases/pets_usecases.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/cubit/pets_cubit.dart';

// Adoption
import 'package:petadopt_prueba2_app/features/adoption/data/datasources/adoption_remote_datasource.dart';
import 'package:petadopt_prueba2_app/features/adoption/data/repositories/adoption_repository_impl.dart';
import 'package:petadopt_prueba2_app/features/adoption/domain/usecases/adoption_usecases.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/cubit/adoption_cubit.dart';

// Chat AI
import 'package:petadopt_prueba2_app/features/chat_ai/data/datasources/chat_ai_remote_datasource.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/data/datasources/chat_ai_local_datasource.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/data/repositories/chat_ai_repository_impl.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/domain/usecases/chat_ai_usecases.dart';
import 'package:petadopt_prueba2_app/features/chat_ai/presentation/cubit/chat_ai_cubit.dart';

// Map
import 'package:petadopt_prueba2_app/features/map/data/datasources/map_local_datasource.dart';
import 'package:petadopt_prueba2_app/features/map/data/repositories/map_repository_impl.dart';
import 'package:petadopt_prueba2_app/features/map/domain/usecases/map_usecases.dart';
import 'package:petadopt_prueba2_app/features/map/presentation/cubit/map_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Auth datasources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  // Auth repository
  sl.registerLazySingleton(() => AuthRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));

  // Auth usecases
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetUserRoleUseCase(repository: sl()));
  sl.registerLazySingleton(() => CheckAuthenticationUseCase(repository: sl()));

  // Auth cubit
  sl.registerFactory(() => AuthCubit(
        registerUseCase: sl(),
        loginUseCase: sl(),
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
        getUserRoleUseCase: sl(),
        checkAuthenticationUseCase: sl(),
      ));

  // Pets datasources
  sl.registerLazySingleton<PetsRemoteDataSource>(
    () => PetsRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Pets repository
  sl.registerLazySingleton(() => PetsRepositoryImpl(remoteDataSource: sl()));

  // Pets usecases
  sl.registerLazySingleton(() => GetAllPetsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetShelterPetsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetPetByIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreatePetUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdatePetUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeletePetUseCase(repository: sl()));

  // Pets cubit
  sl.registerFactory(() => PetsCubit(
        getAllPetsUseCase: sl(),
        getShelterPetsUseCase: sl(),
        getPetByIdUseCase: sl(),
        createPetUseCase: sl(),
        updatePetUseCase: sl(),
        deletePetUseCase: sl(),
      ));

  // Adoption datasources
  sl.registerLazySingleton<AdoptionRemoteDataSource>(
    () => AdoptionRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Adoption repository
  sl.registerLazySingleton(() => AdoptionRepositoryImpl(remoteDataSource: sl()));

  // Adoption usecases
  sl.registerLazySingleton(() => CreateAdoptionRequestUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAdopterRequestsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetShelterRequestsUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateAdoptionRequestStatusUseCase(repository: sl()));

  // Adoption cubit
  sl.registerFactory(() => AdoptionCubit(
        createAdoptionRequestUseCase: sl(),
        getAdopterRequestsUseCase: sl(),
        getShelterRequestsUseCase: sl(),
        updateAdoptionRequestStatusUseCase: sl(),
      ));

  // Chat AI datasources
  sl.registerLazySingleton<ChatAiRemoteDataSource>(
    () => ChatAiRemoteDataSourceImpl(apiKey: AppConstants.geminiApiKey),
  );
  sl.registerLazySingleton<ChatAiLocalDataSource>(
    () => ChatAiLocalDataSourceImpl(),
  );

  // Chat AI repository
  sl.registerLazySingleton(() => ChatAiRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));

  // Chat AI usecases
  sl.registerLazySingleton(() => SendMessageUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetConversationHistoryUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveConversationHistoryUseCase(repository: sl()));
  sl.registerLazySingleton(() => ClearConversationHistoryUseCase(repository: sl()));

  // Chat AI cubit
  sl.registerFactory(() => ChatAiCubit(
        sendMessageUseCase: sl(),
        getConversationHistoryUseCase: sl(),
        saveConversationHistoryUseCase: sl(),
        clearConversationHistoryUseCase: sl(),
      ));

  // Map datasources
  sl.registerLazySingleton<MapLocalDataSource>(() => MapLocalDataSourceImpl());

  // Map repository
  sl.registerLazySingleton(() => MapRepositoryImpl(localDataSource: sl()));

  // Map usecases
  sl.registerLazySingleton(() => GetCurrentLocationUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetShelterPinsUseCase(repository: sl()));

  // Map cubit
  sl.registerFactory(() => MapCubit(
        getCurrentLocationUseCase: sl(),
        getShelterPinsUseCase: sl(),
      ));
}
