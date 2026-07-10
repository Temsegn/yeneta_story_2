import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/features/games/data/datasources/games_remote_datasource.dart';

final gamesDataSourceProvider = Provider<GamesRemoteDataSourceImpl>((ref) {
  return GamesRemoteDataSourceImpl();
});
