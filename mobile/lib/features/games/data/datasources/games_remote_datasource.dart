import '../../../../core/data/sample_data.dart';
import '../../domain/entities/game_entity.dart';

abstract class GamesRemoteDataSource {
  Future<List<GameEntity>> getGamesByAge(String ageGroup);
}

class GamesRemoteDataSourceImpl implements GamesRemoteDataSource {
  @override
  Future<List<GameEntity>> getGamesByAge(String ageGroup) async {
    // Games are bundled locally; always return the playable sample set.
    return SampleData.games();
  }
}
