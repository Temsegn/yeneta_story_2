import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/subscription_remote_datasource.dart';
import '../../data/models/subscription_models.dart';
import '../../../../core/providers/dio_provider.dart';

final subscriptionRemoteDataSourceProvider =
    Provider<SubscriptionRemoteDataSource>((ref) {
  final dio = ref.read(dioClientProvider).dio;
  return SubscriptionRemoteDataSourceImpl(dio);
});

final accessInfoProvider = StateProvider<AccessInfo?>((ref) => null);

final subscriptionLoadingProvider = StateProvider<bool>((ref) => false);
