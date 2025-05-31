import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/ui/screen/admin/user_info_bottom_sheet.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';

import '../../../blocs/auth/user_info_cubit.dart';
import '../../../blocs/base_bloc/base_state.dart';
import '../../../blocs/registration/list_registration_cubit.dart';
import '../../../data/models/course_model.dart';
import '../../../data/models/registration_model.dart';
import '../../../res/colors.dart';
import '../../../util/constants.dart';
import '../../widget/base_text_input.dart';
import '../../widget/common_widget.dart';
import '../../widget/widget.dart';

class StudentManageScreen extends StatelessWidget {
  final CourseModel? arg;

  const StudentManageScreen({Key? key, this.arg}) : super(key: key);

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
      ],
      child: StudentManageBody(arg: arg,)
    );
  }
}


class StudentManageBody extends StatefulWidget {
  final CourseModel? arg;

  const StudentManageBody({Key? key, this.arg}) : super(key: key);

  @override
  State<StudentManageBody> createState() => _StudentManageBodyState();
}

class _StudentManageBodyState extends State<StudentManageBody> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    if (widget.arg is CourseModel && widget.arg != null) {
      getData();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void getData({String? finalTestStatus}) {
    Map<String, dynamic> param = {
      'course_id': widget.arg!.id,
      'status': 'accepted',
      'search_name': searchController.text,
      'final_test_passed': finalTestStatus ?? ''
    };
    context.read<ListRegistrationCubit>().getListRegistration(param);
  }

  void _onSearchChanged() {
    getData();
  }

  void _onStudentInfo(RegistrationModel registration) async {
    showModalBottomSheet(
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
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hideAppBar: true,
      colorBackground: AppColors.background_white,
      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              Flexible(
                flex: 3,
                child: CustomTextInput(
                  textController: searchController,
                  margin: EdgeInsets.only(left: 20, right: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Tìm kiếm',
                  suffixIcon: Icon(Icons.search_rounded),
                ),
              ),
              Flexible(
                flex: 2,
                child: CustomTextInput(
                  margin: EdgeInsets.only(right: 20),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Trạng thái',
                  isDropdownTF: true,
                  suffixIconMargin: 0,
                  dropdownItems: Constants.studentStatus,
                  onDropdownChanged: (value) {
                    getData(finalTestStatus: value!.additionalData);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.black,
              backgroundColor: AppColors.white,
              onRefresh: () async => getData(),
              child: BlocBuilder<ListRegistrationCubit, BaseState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return Center(
                      child: BaseProgressIndicator(color: AppColors.black,),
                    );
                  }
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
                              onTap: () {
                                _onStudentInfo(registration.copyWith(isApproval: false));
                              }
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                      );
                    } else {
                      return Center(
                        child: CustomTextLabel('Chưa có học sinh nào'),
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
}
