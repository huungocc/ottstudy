import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';

import '../../data/models/question_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class CreateQuestionCubit extends Cubit<BaseState> {
  CreateQuestionCubit() : super(InitState());

  Future<void> createQuestion(Map<String, dynamic>? body) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().post(
        url: ApiConstant.createQuestion,
        body: body,
      );

      if (response.isSuccess) {
        final QuestionModel lessonModel = QuestionModel.fromJson(response.data);

        emit(LoadedState<QuestionModel>(lessonModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

}
