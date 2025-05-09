import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';
import 'package:ottstudy/blocs/utils.dart';
import 'package:ottstudy/data/models/upload_file_model.dart';
import 'package:ottstudy/data/network/api_response.dart';

import '../data/network/api_constant.dart';
import '../data/network/network_impl.dart';

class UploadFileCubit extends Cubit<BaseState> {
  UploadFileCubit() : super(InitState());

  Future<void> uploadFile(File file) async {
    try {
      emit(LoadingState());

      // Correct way to create FormData with fields
      FormData formData = FormData.fromMap({
        "partner": "android", // Add any other fields you need
      });

      // Add the file to formData
      formData.files.add(
        MapEntry(
          "file",
          await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
        ),
      );

      ApiResponse response = await Network().post(
          url: ApiConstant.uploadFile,
          body: formData,
          isOriginData: true,
          contentType: 'multipart/form-data'
      );

      if (response.isSuccess) {
        UploadFileModel uploadFileModel = UploadFileModel.fromJson(response.data);
        emit(LoadedState<UploadFileModel>(uploadFileModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}