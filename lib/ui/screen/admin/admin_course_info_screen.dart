import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/course/course_info_cubit.dart';
import 'package:ottstudy/blocs/lesson/list_lesson_cubit.dart';
import 'package:ottstudy/data/models/course_model.dart';
import 'package:ottstudy/data/models/lesson_model.dart';
import 'package:ottstudy/ui/widget/base_loading.dart';
import 'package:ottstudy/ui/widget/base_network_image.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';

import '../../../blocs/base_bloc/base_state.dart';
import '../../../blocs/test/test_info_cubit.dart';
import '../../../data/models/test_model.dart';
import '../../../res/colors.dart';

class AdminCourseInfoScreen extends StatelessWidget {
  final CourseModel? arg;

  const AdminCourseInfoScreen({Key? key, this.arg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CourseInfoCubit(),
        ),
        BlocProvider(
          create: (_) => ListLessonCubit(),
        ),
        BlocProvider(
          create: (_) => TestInfoCubit(),
        ),
      ],
      child: AdminCourseInfoBody(arg: arg,),
    );
  }
}

class AdminCourseInfoBody extends StatefulWidget {
  final CourseModel? arg;

  const AdminCourseInfoBody({Key? key, this.arg}) : super(key: key);

  @override
  State<AdminCourseInfoBody> createState() => _AdminCourseInfoBodyState();
}

class _AdminCourseInfoBodyState extends State<AdminCourseInfoBody> {
  @override
  void initState() {
    super.initState();
    if (widget.arg is CourseModel && widget.arg != null) {
      getCourseData();
    }
  }

  void getCourseData() {
    context.read<CourseInfoCubit>().courseInfo({
      'id': widget.arg!.id,
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hideAppBar: true,
      colorBackground: AppColors.background_white,
      loadingWidget: Stack(children: [
        CustomLoading<CourseInfoCubit>(),
        CustomLoading<ListLessonCubit>(),
      ]),
      body: BlocBuilder<CourseInfoCubit, BaseState>(
        builder: (_, state) {
          if (state is LoadedState<CourseModel>) {
            final courseModel = state.data;
            context.read<ListLessonCubit>().getListLesson({
              'lessonIds': state.data.lessons
            });
            context.read<TestInfoCubit>().testInfo({
              'id': state.data.finalTestId
            });
            return SingleChildScrollView(
              child: Column(
                children: [
                  BaseNetworkImage(
                    url: courseModel.courseImage ?? '',
                    isFromDatabase: true,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        CustomTextLabel(courseModel.teacher ?? 'Không xác định'),
                        const SizedBox(height: 10),
                        CustomTextLabel(
                          courseModel.courseName ?? 'Không xác định',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 10),
                        CommonWidget.courseInfo_2(
                            studentCount: courseModel.studentCount,
                            subjectId: courseModel.subjectId
                        ),
                        const SizedBox(height: 10),
                        CustomTextLabel(courseModel.description ?? 'Không xác định'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  BlocBuilder<ListLessonCubit, BaseState>(
                      builder: (_, state) {
                        if (state is LoadedState<List<LessonModel>>) {
                          final List<LessonModel> lessonList = state.data;
                          if (lessonList.isNotEmpty) {
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: lessonList.length,
                              itemBuilder: (context, index) {
                                final lesson = lessonList[index];
                                return CommonWidget.lessonInfo(
                                  lesson,
                                  order: index + 1,
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(height: 10),
                            );
                          }
                        }
                        return const SizedBox.shrink();
                      }
                  ),
                  BlocBuilder<TestInfoCubit, BaseState>(
                    builder: (_, state) {
                      if (state is LoadedState<TestModel>) {
                        final TestModel testModel = state.data;
                        return CommonWidget.examInfo(
                          testModel,
                        );
                      }
                      return const SizedBox.shrink();
                    }
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
