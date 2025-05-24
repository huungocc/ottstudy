import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';

import '../../data/models/question_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class ListQuestionCubit extends Cubit<BaseState> {
  ListQuestionCubit() : super(InitState());

  Future<void> getListQuestion(Map<String, dynamic>? body) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().post(
        url: ApiConstant.listQuestion,
        body: body,
      );

      if (response.isSuccess) {
        final List<QuestionModel> questionList = (response.data as List)
            .map((item) => QuestionModel.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(LoadedState<List<QuestionModel>>(questionList));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}
