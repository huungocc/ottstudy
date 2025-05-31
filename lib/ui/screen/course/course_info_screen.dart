import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/course/course_info_cubit.dart';
import 'package:ottstudy/blocs/lesson/list_lesson_cubit.dart';
import 'package:ottstudy/blocs/registration/create_registration_cubit.dart';
import 'package:ottstudy/blocs/registration/registration_status_cubit.dart';
import 'package:ottstudy/data/models/course_model.dart';
import 'package:ottstudy/data/models/lesson_model.dart';
import 'package:ottstudy/data/models/registration_model.dart';
import 'package:ottstudy/ui/widget/base_button.dart';
import 'package:ottstudy/ui/widget/base_loading.dart';
import 'package:ottstudy/ui/widget/base_network_image.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';

import '../../../blocs/base_bloc/base_state.dart';
import '../../../blocs/test/test_info_cubit.dart';
import '../../../data/models/test_model.dart';
import '../../../res/colors.dart';
import '../../../util/routes.dart';

class CourseInfoScreen extends StatelessWidget {
  final CourseModel? arg;

  const CourseInfoScreen({Key? key, this.arg}) : super(key: key);

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
        BlocProvider(
          create: (_) => CreateRegistrationCubit(),
        ),
        BlocProvider(
          create: (_) => RegistrationStatusCubit(),
        ),
      ],
      child: CourseInfoBody(arg: arg,),
    );
  }
}

class CourseInfoBody extends StatefulWidget {
  final CourseModel? arg;

  const CourseInfoBody({Key? key, this.arg}) : super(key: key);

  @override
  State<CourseInfoBody> createState() => _CourseInfoBodyState();
}

class _CourseInfoBodyState extends State<CourseInfoBody> {
  String registrationStatus = 'accepted';
  bool finalTestStatus = false;
  String registrationId = '';
  double finalTestScore = 0;

  @override
  void initState() {
    super.initState();
    if (widget.arg is CourseModel && widget.arg != null) {
      getCourseData();
      getRegistrationStatus();
    }
  }

  void getCourseData() {
    context.read<CourseInfoCubit>().courseInfo({
      'id': widget.arg!.id,
    });
  }

  void getRegistrationStatus() {
    context.read<RegistrationStatusCubit>().getRegistrationStatus({
      'course_id': widget.arg!.id,
    });
  }

  void createRegistration() {
    context.read<CreateRegistrationCubit>().createRegistration({
      'course_id': widget.arg!.id,
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildBottomButton() {
    return BlocConsumer<RegistrationStatusCubit, BaseState>(
      listener: (context, state) {
        if (state is LoadedState<RegistrationModel>) {
          setState(() {
            registrationStatus = state.data.status ?? 'none';
            finalTestStatus = state.data.finalTestPassed == null ? false : true;
            registrationId = state.data.id!;
            if (state.data.finalTestScore != null) {
              finalTestScore = state.data.finalTestScore!;
            }
          });
        } else if (state is ErrorState) {
          setState(() {
            registrationStatus = 'none';
          });
        }
      },
      builder: (context, state) {
        return BlocConsumer<CreateRegistrationCubit, BaseState>(
          listener: (context, createState) {
            if (createState is LoadedState<RegistrationModel>) {
              setState(() {
                registrationStatus = 'waiting';
              });
            }
          },
          builder: (context, createState) {
            String buttonTitle;
            VoidCallback? onPressed;

            switch (registrationStatus) {
              case 'none':
                buttonTitle = 'Đăng ký học';
                onPressed = createRegistration;
                break;
              case 'waiting':
                buttonTitle = 'Chờ xét duyệt';
                onPressed = null;
                break;
              case 'accepted':
                buttonTitle = 'Đã được duyệt';
                onPressed = null;
                break;
              default:
                buttonTitle = '';
                onPressed = null;
            }

            return Visibility(
              visible: !(registrationStatus == 'accepted'),
              child: BottomAppBar(
                color: AppColors.background_white,
                child: BaseButton(
                  title: buttonTitle,
                  isDisable: registrationStatus == 'waiting',
                  borderRadius: 20,
                  onTap: registrationStatus == 'none' ? onPressed : null,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLessonItem(LessonModel lesson, int index) {
    bool canAccess = registrationStatus == 'accepted';

    return Opacity(
      opacity: canAccess ? 1.0 : 0.5,
      child: CommonWidget.lessonInfo(
          lesson,
          order: index + 1,
          onTap: canAccess ? () {
            if (lesson.fileType == 'video') {
              Navigator.pushNamed(context, Routes.videoLessonScreen, arguments: lesson);
            } else if (lesson.fileType == 'pdf') {
              Navigator.pushNamed(context, Routes.pdfLessonScreen, arguments: lesson);
            }
          } : () {
            _showSnackBar('Bạn cần đăng ký và được duyệt để truy cập bài học này', isError: true);
          }
      ),
    );
  }

  Widget _buildExamInfo(TestModel testModel, {double finalTestScore = 0}) {
    bool canAccess = registrationStatus == 'accepted';

    return Opacity(
      opacity: canAccess ? 1.0 : 0.5,
      child: CommonWidget.examInfo(
          testModel,
          finalTestScore: finalTestScore,
          onTap: canAccess ? () {
            Navigator.pushNamed(context, Routes.quizScreen, arguments: testModel.copyWith(isFinalTest: true,
                registrationId: registrationId, finalTestStatus: finalTestStatus));
          } : () {
            _showSnackBar('Bạn cần đăng ký và được duyệt để truy cập bài kiểm tra này', isError: true);
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Thông tin khóa học',
      colorBackground: AppColors.background_white,
      loadingWidget: Stack(children: [
        CustomLoading<CourseInfoCubit>(),
        CustomLoading<ListLessonCubit>(),
        CustomLoading<RegistrationStatusCubit>(),
        CustomLoading<CreateRegistrationCubit>(),
      ]),
      body: RefreshIndicator(
        color: AppColors.black,
        backgroundColor: AppColors.white,
        onRefresh: () async {
          getCourseData();
          getRegistrationStatus();
        },
        child: BlocBuilder<CourseInfoCubit, BaseState>(
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
                physics: AlwaysScrollableScrollPhysics(),
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
                          CustomTextLabel(courseModel.teacher ?? 'Không xác định', fontSize: 12, color: AppColors.gray_title,),
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
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: lessonList.length,
                                itemBuilder: (context, index) {
                                  final lesson = lessonList[index];
                                  return _buildLessonItem(lesson, index);
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
                            return _buildExamInfo(testModel, finalTestScore: finalTestScore);
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
      ),
      bottomBar: _buildBottomButton(),
    );
  }
}
