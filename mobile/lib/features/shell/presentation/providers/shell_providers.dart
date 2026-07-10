import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/shell_viewmodel.dart';

export '../viewmodel/shell_viewmodel.dart';

final isPlayerOpenProvider = StateProvider<bool>((ref) => false);
final isEducationAgeSelectedProvider = StateProvider<bool>((ref) => false);
final isReadingStoryProvider = StateProvider<bool>((ref) => false);
final isPlayingGameProvider = StateProvider<bool>((ref) => false);
final selectedVideoProvider = StateProvider<dynamic>((ref) => null);
