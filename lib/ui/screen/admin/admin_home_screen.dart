import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../blocs/base_bloc/base_state.dart';
import '../../../blocs/course/list_course_cubit.dart';
import '../../../data/models/course_model.dart';
import '../../../res/colors.dart';
import '../../../util/routes.dart';
import '../../../util/shared_preference.dart';
import '../../widget/base_progress_indicator.dart';
import '../../widget/base_screen.dart';
import '../../widget/base_text_input.dart';
import '../../widget/common_widget.dart';
import '../../widget/custom_snack_bar.dart';
import '../../widget/custom_text_label.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListCourseCubit(),
      child: AdminHomeBody(),
    );
  }
}

class AdminHomeBody extends StatefulWidget {
  const AdminHomeBody({super.key});

  @override
  State<AdminHomeBody> createState() => _AdminHomeBodyState();
}

class _AdminHomeBodyState extends State<AdminHomeBody> {
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

  void getData() {
    Map<String,dynamic> param = {
      'keyword': searchController.text,
    };
    context.read<ListCourseCubit>().getListCourse(param);
  }

  void _onSearchChanged() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hiddenIconBack: true,
      colorBackground: AppColors.background_white,
      colorAppBar: AppColors.background_white,
      messageNotify: CustomSnackBar<ListCourseCubit>(),
      title: const Align(
        alignment: Alignment.centerLeft,
        child: CustomTextLabel(
          'Quản lý',
          gradient: AppColors.base_gradient_1,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      rightWidgets: [
        GestureDetector(
          onTap: () {
            //
          },
          child: PhosphorIcon(
            PhosphorIcons.chartBar(),
            color: AppColors.black,
            size: 30,
          ),
        ),
        SizedBox(width: 20,),
        GestureDetector(
          onTap: () async {
            await SharedPreferenceUtil.clearData();
            Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
          },
          child: PhosphorIcon(
            PhosphorIcons.signOut(),
            color: Colors.red,
            size: 30,
          ),
        ),
        SizedBox(width: 20,)
      ],
      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                flex: 2,
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.adminCourseEditScreen);
                },
                child: PhosphorIcon(
                  PhosphorIcons.plusCircle(),
                  size: 30,
                ),
              ),
              SizedBox(width: 20,)
            ],
          ),
          SizedBox(height: 20,),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.black,
              backgroundColor: AppColors.white,
              onRefresh: () async => getData(),
              child: BlocBuilder<ListCourseCubit, BaseState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Center(
                      child: BaseProgressIndicator(color: AppColors.black,),
                    );
                  }
                  if (state is LoadedState<List<CourseModel>>) {
                    final List<CourseModel> courseList = state.data;
                    if (courseList.isNotEmpty) {
                      return ListView.separated(
                        itemCount: courseList.length,
                        itemBuilder: (context, index) {
                          final course = courseList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: CommonWidget.adminCourseCard(
                              course,
                              onTap: () {
                                Navigator.pushNamed(context, Routes.adminCourseManageScreen, arguments: course);
                              },
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                      );
                    } else {
                      return Center(
                        child: CustomTextLabel('Chưa có khóa học nào'),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            )
          )
        ],
      ),
    );
  }
}

