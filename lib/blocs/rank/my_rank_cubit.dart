import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';
import 'package:ottstudy/data/models/rank_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class MyRankCubit extends Cubit<BaseState> {
  MyRankCubit() : super(InitState());

  Future<void> getMyRank(Map<String, dynamic> param) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().get(
        url: ApiConstant.myRank,
        params: param,
      );

      if (response.isSuccess) {
        final RankModel rankModel = RankModel.fromJson(response.data);

        emit(LoadedState<RankModel>(rankModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      print(e);
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}