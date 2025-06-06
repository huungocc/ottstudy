import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/registration/my_registration_cubit.dart';
import 'package:ottstudy/data/models/course_model.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';

import '../../../blocs/base_bloc/base_state.dart';
import '../../../res/colors.dart';
import '../../../util/constants.dart';
import '../../../util/routes.dart';
import '../../widget/base_progress_indicator.dart';
import '../../widget/base_screen.dart';
import '../../widget/base_text_input.dart';
import '../../widget/custom_snack_bar.dart';
import '../../widget/custom_text_label.dart';

class MyCourseScreen extends StatelessWidget {
  const MyCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyRegistrationCubit(),
      child: MyCourseBody(),
    );
  }
}

class MyCourseBody extends StatefulWidget {
  const MyCourseBody({super.key});

  @override
  State<MyCourseBody> createState() => _MyCourseBodyState();
}

class _MyCourseBodyState extends State<MyCourseBody> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    getData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void getData({String? status}) {
    Map<String, dynamic> params = {
      'keyword': searchController.text,
      'final_test_passed': status ?? ''
    };
    context.read<MyRegistrationCubit>().getMyRegistration(params);
  }

  void _onSearchChanged() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Khóa học của tôi',
      colorBackground: AppColors.background_white,
      messageNotify: CustomSnackBar<MyRegistrationCubit>(),
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
                    getData(status: value!.additionalData);
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
              child: BlocBuilder<MyRegistrationCubit, BaseState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Center(
                      child: BaseProgressIndicator(color: AppColors.black,),
                    );
                  }
                  if (state is LoadedState<List<CourseModel>>) {
                    final List<CourseModel> courseList = state.data;
                    if (courseList.isNotEmpty) {
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        itemCount: courseList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 items mỗi hàng
                          crossAxisSpacing: 10, // khoảng cách ngang giữa các item
                          mainAxisSpacing: 10,  // khoảng cách dọc giữa các item
                          childAspectRatio: 1.1, // tỷ lệ chiều rộng / chiều cao (tùy vào thiết kế card)
                        ),
                        itemBuilder: (context, index) {
                          final course = courseList[index];
                          return CommonWidget.myCourseCard(
                            course,
                            onTap: () {
                              Navigator.pushNamed(context, Routes.courseInfoScreen, arguments: course);
                            },
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CustomTextLabel('Không có dữ liệu'),
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

