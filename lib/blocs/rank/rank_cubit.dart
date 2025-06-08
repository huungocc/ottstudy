import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/data/models/rank_model.dart';

import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../base_bloc/base_state.dart';
import '../utils.dart';

class RankCubit extends Cubit<BaseState> {
  RankCubit() : super(InitState());

  Future<void> getRank(Map<String, dynamic> param) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().get(
        url: ApiConstant.rank,
        params: param,
      );

      if (response.isSuccess) {
        final List<RankModel> rankModel = (response.data as List)
            .map((item) => RankModel.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(LoadedState<List<RankModel>>(rankModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}