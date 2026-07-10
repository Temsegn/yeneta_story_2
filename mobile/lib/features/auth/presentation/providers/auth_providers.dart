import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/auth_models.dart';
import '../../../../core/providers/dio_provider.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.read(dioClientProvider).dio;
  final tokenStorage = ref.read(tokenStorageProvider);
  return AuthRemoteDataSourceImpl(dio, tokenStorage);
});

final authStateProvider = StateProvider<UserData?>((ref) => null);
