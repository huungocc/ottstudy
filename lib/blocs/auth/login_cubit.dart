import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../../util/shared_preference.dart';
import '../base_bloc/base.dart';
import '../utils.dart';

class LoginCubit extends Cubit<BaseState> {
  LoginCubit() : super(InitState());

  Future<void> doLogin(Map<String, dynamic> body) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().post(url: ApiConstant.login, body: body);

      if (response.isSuccess) {
        UserModel userModel = UserModel.fromJson(response.data["user"]);
        await SharedPreferenceUtil.saveToken(userModel.token ?? '');
        await SharedPreferenceUtil.saveRole(userModel.role ?? '');
        emit(LoadedState<UserModel>(userModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}