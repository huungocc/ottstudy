import 'package:flutter_bloc/flutter_bloc.dart';
import '../base_bloc/base.dart';

class LoginCubit extends Cubit<BaseState> {
  LoginCubit() : super(InitState());

  doLogin({String? userName, String? password}) async {
    // try {
    //   emit(LoadingState());
    //
    //   emit(LoadedState());
    // } catch (e) {
    //   emit(ErrorState(BlocUtils.getMessageError(e)));
    // }
  }
}
