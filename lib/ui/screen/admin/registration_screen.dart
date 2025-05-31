import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/auth/user_info_cubit.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';
import 'package:ottstudy/blocs/registration/approve_registration_cubit.dart';
import 'package:ottstudy/blocs/registration/list_registration_cubit.dart';
import 'package:ottstudy/ui/screen/admin/user_info_bottom_sheet.dart';
import 'package:ottstudy/ui/widget/base_progress_indicator.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import '../../../data/models/course_model.dart';
import '../../../data/models/registration_model.dart';
import '../../../data/models/user_model.dart';
import '../../../res/colors.dart';
import '../../../util/common.dart';
import '../../widget/base_button.dart';
import '../../widget/base_loading.dart';
import '../../widget/base_network_image.dart';
import '../../widget/common_widget.dart';
import '../../widget/custom_text_label.dart';

class RegistrationScreen extends StatelessWidget {
  final CourseModel? arg;

  const RegistrationScreen({Key? key, this.arg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ListRegistrationCubit(),
        ),
        BlocProvider(
          create: (_) => UserInfoCubit(),
        ),
        BlocProvider(
          create: (_) => ApproveRegistrationCubit(),
        ),
      ],
      child: RegistrationBody(arg: arg),
    );
  }
}

class RegistrationBody extends StatefulWidget {
  final CourseModel? arg;

  const RegistrationBody({Key? key, this.arg}) : super(key: key);

  @override
  State<RegistrationBody> createState() => _RegistrationBodyState();
}

class _RegistrationBodyState extends State<RegistrationBody> {
  @override
  void initState() {
    super.initState();
    if (widget.arg is CourseModel && widget.arg != null) {
      getData();
    }
  }

  void getData() {
    Map<String, dynamic> param = {
      'course_id': widget.arg!.id
    };

    context.read<ListRegistrationCubit>().getListRegistration(param);
  }

  void _onRegistration(RegistrationModel registration) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: AppColors.background_white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: UserInfoBottomSheet(
          arg: registration,
        ),
      ),
    );
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hideAppBar: true,
      colorBackground: AppColors.background_white,
      loadingWidget: CustomLoading<ListRegistrationCubit>(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.black,
              backgroundColor: AppColors.white,
              onRefresh: () async => getData(),
              child: BlocBuilder<ListRegistrationCubit, BaseState>(
                builder: (context, state) {
                  if (state is LoadedState<List<RegistrationModel>>) {
                    final List<RegistrationModel> registrationList = state.data;
                    if (registrationList.isNotEmpty) {
                      return ListView.separated(
                        itemCount: registrationList.length,
                        itemBuilder: (context, index) {
                          final registration = registrationList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: CommonWidget.studentCard(
                                registration,
                                isFinished: false,
                                onTap: () {
                                  _onRegistration(registration.copyWith(isApproval: true));
                                }
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                      );
                    } else {
                      return Center(
                        child: CustomTextLabel('Chưa có đơn đăng ký nào'),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget studentInfo(UserModel userModel, {
    required bool isApproving,
    VoidCallback? onApprove,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thông tin học sinh',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
            ),
          ],
        ),
        SizedBox(height: 20),

        // Avatar
        BaseNetworkImage(
          url: userModel.avatarUrl ?? '',
          isFromDatabase: true,
          height: 100,
          width: 100,
          boxFit: BoxFit.cover,
          borderRadius: 50,
        ),
        SizedBox(height: 20),

        // Thông tin học sinh
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
          value: userModel.birthDate ?? 'N/A',
        ),
        CommonWidget.studentInfoText(
          title: 'Số điện thoại',
          value: userModel.phoneNumber ?? 'N/A',
        ),
        CommonWidget.studentInfoText(
          title: 'Lớp',
          value: userModel.grade.toString(),
        ),

        SizedBox(height: 20),

        // Nút phê duyệt
        Visibility(
          visible: isApproving,
          child: BaseButton(
            title: 'Phê duyệt',
            borderRadius: 20,
            onTap: onApprove,
          ),
        ),

        SizedBox(height: 20),
      ],
    );
  }
}