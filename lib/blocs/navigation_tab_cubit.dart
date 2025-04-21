import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_bloc/navigation_tab_state.dart';

class NavigationTabCubit extends Cubit<NavigationTabState> {
  NavigationTabCubit() : super(NavigationTabState(0));

  void changeIndex(int index) {
    emit(NavigationTabState(index));
  }
}