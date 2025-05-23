import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/course/list_course_cubit.dart';
import 'package:ottstudy/data/models/course_model.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/base_text_input.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';
import 'package:ottstudy/ui/widget/custom_selector.dart';
import 'package:ottstudy/ui/widget/custom_snack_bar.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';
import '../../../blocs/base_bloc/base_state.dart';
import '../../../gen/assets.gen.dart';
import '../../../res/colors.dart';
import '../../../util/constants.dart';
import '../../../util/routes.dart';
import '../../widget/base_progress_indicator.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListCourseCubit(),
      child: ExploreBody(),
    );
  }
}

class ExploreBody extends StatefulWidget {
  const ExploreBody({super.key});

  @override
  State<ExploreBody> createState() => _ExploreBodyState();
}

class _ExploreBodyState extends State<ExploreBody> {
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

  void getData({bool isRefresh = false, int? grade, String? subjectId}) {
    Map<String,dynamic> param;
    if (isRefresh == true) {
      param = {};
    } else {
      param = {
        'keyword': searchController.text,
        if (grade != null) 'grade': grade,
        'subject_id': subjectId ?? ''
      };
    }
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
      //loadingWidget: CustomLoading<ListCourseCubit>(),
      messageNotify: CustomSnackBar<ListCourseCubit>(),
      title: const Align(
        alignment: Alignment.centerLeft,
        child: CustomTextLabel(
          'Khám phá',
          gradient: AppColors.base_gradient_1,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      rightWidgets: [Assets.images.icExplorer.image(), SizedBox(width: 20,)],
      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              Flexible(
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
              Flexible(
                flex: 1,
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
                  hintText: 'Lớp',
                  isDropdownTF: true,
                  suffixIconMargin: 0,
                  dropdownItems: Constants.grades,
                  onDropdownChanged: (value) {
                    getData(grade: value!.id);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          CustomSelector(
            items: Constants.subjectFilter,
            onTap: (id, index) {
              getData(subjectId: id);
            },
          ),
          SizedBox(height: 20,),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.black,
              backgroundColor: AppColors.white,
              onRefresh: () async => getData(isRefresh: true),
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
                            child: CommonWidget.explorerCourseCard(
                              course,
                              onTap: () {
                                Navigator.pushNamed(context, Routes.courseInfoScreen);
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