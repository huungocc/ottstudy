import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';
import 'package:ottstudy/blocs/registration/approve_registration_cubit.dart';
import 'package:ottstudy/ui/widget/base_loading.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/custom_snack_bar.dart';

import '../../../blocs/auth/user_info_cubit.dart';
import '../../../data/models/registration_model.dart';
import '../../../data/models/user_model.dart';
import '../../../res/colors.dart';
import '../../../util/common.dart';
import '../../widget/base_button.dart';
import '../../widget/base_network_image.dart';
import '../../widget/base_progress_indicator.dart';
import '../../widget/common_widget.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/custom_text_label.dart';

class UserInfoBottomSheet extends StatelessWidget {
  final RegistrationModel? arg;

  const UserInfoBottomSheet({
    Key? key, this.arg,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserInfoCubit(),
        ),
        BlocProvider(
          create: (_) => ApproveRegistrationCubit(),
        )
      ],
      child: UserInfoBottomSheetBody(arg: arg,),
    );
  }
}


class UserInfoBottomSheetBody extends StatefulWidget {
  final RegistrationModel? arg;

  const UserInfoBottomSheetBody({
    Key? key, this.arg,}) : super(key: key);

  @override
  State<UserInfoBottomSheetBody> createState() => _UserInfoBottomSheetBodyState();
}

class _UserInfoBottomSheetBodyState extends State<UserInfoBottomSheetBody> {

  @override
  void initState() {
    super.initState();
    if (widget.arg is RegistrationModel && widget.arg != null) {
      getData();
    }
  }

  void getData() async {
    Map<String, dynamic> param = {
      'user_id': widget.arg!.userId,
    };

    context.read<UserInfoCubit>().getUserInfoByAdmin(param);
  }

  void _handleApproval() {
    Map<String, dynamic> body = {
      'registration_id': widget.arg!.id
    };
    context.read<ApproveRegistrationCubit>().approveRegistration(body);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hideAppBar: true,
      colorBackground: AppColors.background_white,
      loadingWidget: CustomLoading<ApproveRegistrationCubit>(),
      messageNotify: Stack(
        children: [
          CustomSnackBar<UserInfoCubit>(),
          CustomSnackBar<ApproveRegistrationCubit>(),
        ],
      ),
      body: BlocBuilder<UserInfoCubit, BaseState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              child: BaseProgressIndicator(color: AppColors.black,),
            );
          }
          if (state is LoadedState<UserModel>) {
            final UserModel userModel = state.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocListener<ApproveRegistrationCubit, BaseState>(
                  listener: (_, state) {
                    if (state is LoadedState<bool>) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(
                            content: 'Phê duyệt thành công',
                            onSubmit: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          );
                        }
                      );
                    }
                  },
                  child: Container(),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomTextLabel(
                      'Thông tin học sinh',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      BaseNetworkImage(
                        url: userModel.avatarUrl ?? '',
                        isFromDatabase: true,
                        height: 100,
                        width: 100,
                        boxFit: BoxFit.cover,
                        borderRadius: 50,
                      ),
                      const SizedBox(height: 30),
                      CommonWidget.studentInfoText(
                        title: 'Mã học sinh',
                        value: userModel.studentCode ?? 'N/A',
                      ),
                      CommonWidget.studentInfoText(
                        title: 'Họ và tên',
                        value: userModel.fullName ?? 'N/A',
                      ),
                      CommonWidget.studentInfoText(
                        title: 'Ngày sinh',
                        value: Common.convertDateToFormat(userModel.birthDate),
                      ),
                      CommonWidget.studentInfoText(
                        title: 'Số điện thoại',
                        value: userModel.phoneNumber ?? 'N/A',
                      ),
                      CommonWidget.studentInfoText(
                        title: 'Lớp',
                        value: userModel.grade.toString(),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      bottomBar: BottomAppBar(
        height: 70,
        color: AppColors.background_white,
        child: Visibility(
          visible: widget.arg!.isApproval == true,
          child: BaseButton(
            title: 'Phê duyệt',
            borderRadius: 20,
            onTap: _handleApproval,
          ),
        ),
      ),
    );
  }
}