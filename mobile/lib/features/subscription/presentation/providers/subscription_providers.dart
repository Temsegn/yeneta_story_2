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

/// Refreshes entitlement from the server and updates every premium gate.
Future<AccessInfo?> refreshAccessInfo(WidgetRef ref) async {
  if (ref.read(subscriptionLoadingProvider)) {
    return ref.read(accessInfoProvider);
  }

  ref.read(subscriptionLoadingProvider.notifier).state = true;
  try {
    final dataSource = ref.read(subscriptionRemoteDataSourceProvider);
    final accessInfo = await dataSource.getMySubscription();
    ref.read(accessInfoProvider.notifier).state = accessInfo;
    return accessInfo;
  } finally {
    ref.read(subscriptionLoadingProvider.notifier).state = false;
  }
}
