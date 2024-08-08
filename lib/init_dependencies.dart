import 'package:get_it/get_it.dart';
import 'package:voltican_fitness/Features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:voltican_fitness/Features/auth/data/repositories/auth_repo_impl.dart';
import 'package:voltican_fitness/Features/auth/domain/repositories/auth_repositories.dart';
import 'package:voltican_fitness/Features/auth/domain/usecases/login_usecase.dart';
import 'package:voltican_fitness/Features/auth/domain/usecases/signup_usecase.dart';
import 'package:voltican_fitness/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voltican_fitness/classes/dio_client.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initAuth();
}

void _initAuth() {
  serviceLocator.registerFactory(() => DioClient());
  serviceLocator
      .registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
  serviceLocator.registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: serviceLocator()));

  serviceLocator.registerFactory(() => SignUpUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => LoginUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => AuthBloc(
      signUpUseCase: serviceLocator(), loginUseCase: serviceLocator()));
}
