import 'package:get_it/get_it.dart';

import 'package:voltican_fitness/Features/recipe/data/datasource/remote_source.dart';
import 'package:voltican_fitness/Features/recipe/data/repositories/repositories/recipe_impl.dart';
import 'package:voltican_fitness/Features/recipe/domain/repositories/recipe_repo.dart';
import 'package:voltican_fitness/Features/recipe/domain/usecases/usecases_recipe.dart';
import 'package:voltican_fitness/Features/recipe/presentation/bloc/recipe_bloc.dart';

final sl = GetIt.instance;

Future<void> initRecipe() async {
  // BLoC
  sl.registerFactory(() => RecipeBloc(
        searchRecipes: sl(),
        getRecipe: sl(),
        createRecipe: sl(),
        updateRecipe: sl(),
        deleteRecipe: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => SearchRecipes(sl()));
  sl.registerLazySingleton(() => GetRecipe(sl()));
  sl.registerLazySingleton(() => CreateRecipe(sl()));
  sl.registerLazySingleton(() => UpdateRecipe(sl()));
  sl.registerLazySingleton(() => DeleteRecipe(sl()));

  // Repository
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl(client: sl()),
  );
}
