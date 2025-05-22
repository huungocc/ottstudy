import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/utils.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import 'base_bloc/base_state.dart';

class DeleteCubit extends Cubit<BaseState> {
  DeleteCubit() : super(InitState());

  Future<void> doDelete(Map<String, dynamic> body) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().post(url: ApiConstant.delete, body: body);

      if (response.isSuccess) {
        emit(LoadedState<bool>(true));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}