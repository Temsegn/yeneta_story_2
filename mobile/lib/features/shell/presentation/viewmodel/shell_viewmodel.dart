import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TabType { library, video, home, education, games }

class ShellViewModel extends Notifier<TabType> {
  @override
  TabType build() => TabType.home;

  void setTab(TabType tab) => state = tab;
}

final shellViewModelProvider = NotifierProvider<ShellViewModel, TabType>(ShellViewModel.new);
