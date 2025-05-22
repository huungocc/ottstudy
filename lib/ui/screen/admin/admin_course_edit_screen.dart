import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ottstudy/blocs/upload_file_cubit.dart';
import 'package:ottstudy/data/models/course_model.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../blocs/base_bloc/base_state.dart';
import '../../../blocs/course/create_course_cubit.dart';
import '../../../blocs/question/create_question_cubit.dart';
import '../../../blocs/test/create_test_cubit.dart';
import '../../../data/models/lesson_model.dart';
import '../../../data/models/question_model.dart';
import '../../../data/models/test_model.dart';
import '../../../data/models/upload_file_model.dart';
import '../../../res/colors.dart';
import '../../../util/constants.dart';
import '../../../util/routes.dart';
import '../../widget/common_widget.dart';
import '../../widget/widget.dart';

enum UploadType { courseImage, questionImage }

class AdminCourseEditScreen extends StatelessWidget {
  const AdminCourseEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UploadFileCubit(),
        ),
        BlocProvider(
          create: (_) => CreateCourseCubit(),
        ),
        BlocProvider(
          create: (_) => CreateTestCubit(),
        ),
        BlocProvider(
          create: (_) => CreateQuestionCubit(),
        ),
      ],
      child: AdminCourseEditBody(),
    );
  }
}

class AdminCourseEditBody extends StatefulWidget {
  const AdminCourseEditBody({super.key});

  @override
  State<AdminCourseEditBody> createState() => _AdminCourseEditBodyState();
}

class _AdminCourseEditBodyState extends State<AdminCourseEditBody> {
  List<LessonModel>? lessonList;

  final _keyName = GlobalKey<TextFieldState>();
  final _keyTeacher = GlobalKey<TextFieldState>();
  final _keySubject = GlobalKey<TextFieldState>();
  final _keyGrade = GlobalKey<TextFieldState>();
  final _keyDescription = GlobalKey<TextFieldState>();

  final _keyTestTime = GlobalKey<TextFieldState>();
  final _keyMinimumScore = GlobalKey<TextFieldState>();
  final _keyAnswer = GlobalKey<TextFieldState>();

  final picker = ImagePicker();
  File? _courseImage;
  String? _courseImageUrl;
  File? _questionImage;
  String? _questionImageUrl;
  UploadType? _currentUploadType;

  TestModel? testModel;
  List<QuestionModel>? questionList;

  String? selectedAnswer;

  bool _isAddTestModalOpen = false;
  bool _isAddQuestionModalOpen = false;

  Future showPickImageOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const CustomTextLabel(
                  'Camera',
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  getImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: const CustomTextLabel(
                  'Thư viện',
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pickImagesFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future pickImagesFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (_currentUploadType == UploadType.questionImage) {
        _questionImage = File(pickedFile.path);
        context.read<UploadFileCubit>().uploadFile(_questionImage!);
      } else {
        _courseImage = File(pickedFile.path);
        context.read<UploadFileCubit>().uploadFile(_courseImage!);
      }
    }
  }

  Future getImageFromCamera() async {
    var status = await Permission.camera.status;

    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        if (_currentUploadType == UploadType.questionImage) {
          _questionImage = File(pickedFile.path);
          context.read<UploadFileCubit>().uploadFile(_questionImage!);
        } else {
          _courseImage = File(pickedFile.path);
          context.read<UploadFileCubit>().uploadFile(_courseImage!);
        }
      }
    } else if (status.isPermanentlyDenied) {
      CustomSnackBar.showMessage(context, mess: "Quyền truy cập camera bị từ chối");
    }
  }

  void _onAddTest() {
    if (_isAddTestModalOpen) return;

    _isAddTestModalOpen = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<CreateTestCubit>(),
          ),
          BlocProvider.value(
            value: context.read<CreateQuestionCubit>(),
          ),
          BlocProvider.value(
            value: context.read<UploadFileCubit>(),
          ),
        ],
        child: AddTest(),
      ),
    ).whenComplete(() {
      if (mounted) {
        _isAddTestModalOpen = false;
      }
    });
  }

  void _onAddQuestion({Function()? onQuestionAdded}) {
    if (_isAddQuestionModalOpen) return;

    _isAddQuestionModalOpen = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<CreateQuestionCubit>(),
          ),
          BlocProvider.value(
            value: context.read<UploadFileCubit>(),
          ),
        ],
        child: AddQuestion(onQuestionAdded: onQuestionAdded),
      ),
    ).whenComplete(() {
      if (mounted) {
        _isAddQuestionModalOpen = false;
      }
    });
  }

  void _removeLesson(int index) {
    setState(() {
      // Map<String, dynamic> body = {
      //   'id': questionList![index].id,
      //   'category': 'question'
      // };
      // context.read<DeleteCubit>().doDelete(body);
      lessonList!.removeAt(index);
    });
  }

  void _removeQuestion(int index) {
    if (mounted) {
      // Map<String, dynamic> body = {
      //   'id': questionList![index].id,
      //   'category': 'question'
      // };
      // context.read<DeleteCubit>().doDelete(body);
      questionList!.removeAt(index);
    }
  }

  void _removeTest() {
    if (mounted) {
      // Map<String, dynamic> body = {
      //   'id': testModel!.id,
      //   'category': 'test'
      // };
      // context.read<DeleteCubit>().doDelete(body);
      testModel = null;
      questionList?.clear();
    }
  }

  Future<void> _createTest() async {
    if (_keyTestTime.currentState!.isValid == true &&
        _keyMinimumScore.currentState!.isValid == true &&
        questionList != null &&
        questionList!.isNotEmpty) {
      final test = TestModel(
        time: int.tryParse(_keyTestTime.currentState!.value),
        minimumScore: double.tryParse(_keyMinimumScore.currentState!.value),
        questions: questionList!.map((q) => q.id!).toList(),
      );

      context.read<CreateTestCubit>().createTest(test.toJson());
    }
  }

  Future<void> _createQuestion() async {
    if (_keyAnswer.currentState!.isValid == true && _questionImageUrl != null) {
      final question = QuestionModel(
        questionImage: _questionImageUrl,
        answer: selectedAnswer,
      );

      context.read<CreateQuestionCubit>().createQuestion(question.toJson());
    }
  }

  Future<void> _onAddCourse() async {
    if (_keyName.currentState!.isValid == true &&
        _courseImageUrl != null &&
        _keyTeacher.currentState!.isValid == true &&
        _keySubject.currentState!.isValid == true &&
        _keyGrade.currentState!.selectedDropdownItem!.value.isNotEmpty &&
        _keySubject.currentState!.selectedDropdownItem!.value.isNotEmpty &&
        _keyDescription.currentState!.isValid == true &&
        lessonList != null &&
        testModel != null) {
      final course = CourseModel(
        courseName: _keyName.currentState!.value,
        courseImage: _courseImageUrl,
        teacher: _keyTeacher.currentState!.value,
        grade: _keyGrade.currentState!.selectedDropdownItem!.id,
        subjectId: _keySubject.currentState!.selectedDropdownItem!.additionalData,
        description: _keyDescription.currentState!.value,
        lessons: lessonList!.map((q) => q.id!).toList(),
        finalTestId: testModel!.id
      );
      context.read<CreateCourseCubit>().createCourse(course.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      //hideAppBar: true,
      colorBackground: AppColors.background_white,
      title: 'Tạo khóa học',
      loadingWidget: Stack(
        children: [
          CustomLoading<UploadFileCubit>(),
          CustomLoading<CreateCourseCubit>(),
        ],
      ),
      messageNotify: Stack(
        children: [
          CustomSnackBar<UploadFileCubit>(),
          CustomSnackBar<CreateCourseCubit>(),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocListener<UploadFileCubit, BaseState>(
                listener: (_, state) {
                  if (state is LoadedState<UploadFileModel>) {
                    if (_currentUploadType == UploadType.questionImage) {
                      setState(() {
                        _questionImageUrl = state.data.path;
                      });
                    } else {
                      setState(() {
                        _courseImageUrl = state.data.path;
                      });
                    }
                  }
                },
                child: Container(),
              ),
              BlocListener<CreateCourseCubit, BaseState>(
                listener: (_, state) {
                  if (state is LoadedState) {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return CustomDialog(
                          content: 'Tạo khóa học thành công',
                          onSubmit: () {
                            Navigator.pop(dialogContext);
                            // Navigator.pop(context, lessonModel);
                          }
                        );
                      }
                    );
                  }
                },
                child: Container(),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextLabel(
                    'Hình ảnh khóa học',
                    fontWeight: FontWeight.bold,
                    isRequired: true,
                  ),
                  BaseButton(
                    onTap: () {
                      _currentUploadType = UploadType.courseImage;
                      showPickImageOptions();
                    },
                    gradient: AppColors.base_gradient_1,
                    borderRadius: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomTextLabel(
                          'Tải ảnh lên',
                          color: AppColors.white,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Icon(PhosphorIcons.image(), color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              _courseImageUrl != null
                  ? BaseNetworkImage(
                      url: _courseImageUrl,
                      isFromDatabase: true,
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 20,
              ),
              CustomTextLabel(
                'Thông tin cơ bản',
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextInput(
                key: _keyName,
                isRequired: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Tên khóa học",
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Tên không được để trống";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextInput(
                key: _keyTeacher,
                isRequired: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Giáo viên",
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Giáo viên không được để trống";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextInput(
                      key: _keySubject,
                      isRequired: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Môn học",
                      isDropdownTF: true,
                      suffixIconMargin: 0,
                      dropdownItems: Constants.subjects,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Môn học không được để trống";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomTextInput(
                      key: _keyGrade,
                      isRequired: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Lớp",
                      isDropdownTF: true,
                      suffixIconMargin: 0,
                      dropdownItems: Constants.grades,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Lớp không được để trống";
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextInput(
                key: _keyDescription,
                isRequired: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Mô tả",
                maxLines: 5,
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Mô tả không được để trống";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextLabel(
                'Danh sách bài học',
                fontWeight: FontWeight.bold,
                isRequired: true,
              ),
              const SizedBox(
                height: 10,
              ),
              if (lessonList != null && lessonList!.isNotEmpty) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: lessonList!.length,
                  itemBuilder: (context, index) {
                    final lesson = lessonList![index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                _removeLesson(index);
                                setState(() {});
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Xoá',
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ],
                        ),
                        child: CommonWidget.lessonInfo(
                          lesson,
                          order: index + 1,
                          borderRadius: 20,
                        ),
                      ),
                    );
                  },
                ),
              ] else ...[
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: CustomTextLabel(
                      'Chưa có bài học nào',
                      color: AppColors.gray_title,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
              const SizedBox(
                height: 10,
              ),
              CommonWidget.addButton(
                  title: 'Thêm bài học',
                  onTap: () async {
                    final result = await Navigator.pushNamed(context, Routes.adminLessonEditScreen);
                    if (result != null && result is LessonModel) {
                      setState(() {
                        lessonList = (lessonList ?? [])..add(result);
                      });
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              CustomTextLabel(
                'Bài kiểm tra kết thúc',
                fontWeight: FontWeight.bold,
                isRequired: true,
              ),
              const SizedBox(
                height: 10,
              ),
              if (testModel != null) ...[
                Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _removeTest();
                          setState(() {

                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Xoá',
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ],
                  ),

                  child: CommonWidget.testInfo(testModel!),
                )
              ] else ...[
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: CustomTextLabel(
                      'Chưa có bài kiểm tra',
                      color: AppColors.gray_title,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CommonWidget.addButton(
                    title: 'Bài kiểm tra',
                    onTap: () {
                      _onAddTest();
                    }),
              ]
            ],
          ),
        ),
      ),
      bottomBar: BottomAppBar(
        color: AppColors.background_white,
        height: 70,
        child: BaseButton(
          title: 'Tạo khóa học',
          borderRadius: 20,
          onTap: () {
            _onAddCourse();
          },
        ),
      ),
    );
  }

  Widget AddTest() {
    return StatefulBuilder(builder: (context, setTestState) {
      return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: AppColors.background_white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: double.infinity,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          children: [
            BlocListener<CreateTestCubit, BaseState>(
              listener: (_, state) {
                if (!mounted) return;

                if (state is LoadingState) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(
                          child: BaseProgressIndicator(),
                        );
                      });
                }
                if (state is LoadedState<TestModel>) {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  if (mounted) {
                    setState(() {
                      testModel = state.data;
                    });
                  }
                  showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return CustomDialog(
                            content: 'Tạo bài kiểm tra thành công',
                            onSubmit: () {
                              if (Navigator.canPop(dialogContext)) {
                                Navigator.pop(dialogContext);
                              }
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            });
                      });
                } else if (state is ErrorState) {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return CustomDialog(
                            content: 'Đã có lỗi xảy ra',
                            onSubmit: () {
                              if (Navigator.canPop(dialogContext)) {
                                Navigator.pop(dialogContext);
                              }
                            });
                      });
                }
              },
              child: Container(),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextInput(
                      key: _keyTestTime,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Thời gian làm bài (phút)",
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Vui lòng nhập thời gian";
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null) {
                          return "Vui lòng nhập số hợp lệ";
                        }
                        if (intValue <= 0 || intValue > 90) {
                          return "Thời gian phải từ 1 đến 90 phút";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextInput(
                      key: _keyMinimumScore,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Điểm yêu cầu",
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Vui lòng nhập điểm yêu cầu";
                        }
                        final doubleValue = double.tryParse(value);
                        if (doubleValue == null) {
                          return "Vui lòng nhập số hợp lệ";
                        }
                        if (doubleValue < 0 || doubleValue > 10) {
                          return "Điểm phải từ 0 đến 10";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const CustomTextLabel(
                      'Danh sách câu hỏi',
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (questionList != null && questionList!.isNotEmpty) ...[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: questionList!.length,
                        itemBuilder: (context, index) {
                          final question = questionList![index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      _removeQuestion(index);
                                      setTestState(() {});
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Xoá',
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ],
                              ),
                              child: CommonWidget.questionInfo(question, order: index + 1),
                            ),
                          );
                        },
                      ),
                    ] else ...[
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Center(
                          child: CustomTextLabel(
                            'Chưa có câu hỏi nào',
                            color: AppColors.gray_title,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    CommonWidget.addButton(
                      title: 'Thêm câu hỏi',
                      onTap: () {
                        _onAddQuestion(onQuestionAdded: () {
                          setTestState(() {});
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            BaseButton(
              margin: EdgeInsets.only(top: 20),
              title: 'Tạo bài kiểm tra',
              borderRadius: 20,
              onTap: () {
                if (questionList == null || questionList!.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return CustomDialog(
                            content: 'Vui lòng thêm ít nhất 1 câu hỏi',
                            onSubmit: () {
                              if (Navigator.canPop(dialogContext)) {
                                Navigator.pop(dialogContext);
                              }
                            });
                      });
                  return;
                }
                _createTest();
              },
            ),
          ],
        ),
      );
    });
  }

  Widget AddQuestion({Function()? onQuestionAdded}) {
    return StatefulBuilder(builder: (context, setQuestionState) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: AppColors.background_white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocListener<UploadFileCubit, BaseState>(
              listener: (_, state) {
                if (!mounted) return;

                if (_currentUploadType == UploadType.questionImage) {
                  if (state is LoadingState) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Center(
                            child: BaseProgressIndicator(),
                          );
                        });
                  }
                  if (state is LoadedState<UploadFileModel>) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    if (mounted) {
                      setQuestionState(() {
                        _questionImageUrl = state.data.path;
                      });
                    }
                  }
                }
              },
              child: Container(),
            ),
            BlocListener<CreateQuestionCubit, BaseState>(
              listener: (_, state) {
                if (!mounted) return;

                if (state is LoadingState) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(
                          child: BaseProgressIndicator(),
                        );
                      });
                }
                if (state is LoadedState<QuestionModel>) {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  if (mounted) {
                    if (questionList == null) {
                      questionList = [];
                    }

                    questionList!.add(state.data);

                    _questionImage = null;
                    _questionImageUrl = null;
                    selectedAnswer = null;

                    onQuestionAdded?.call();
                  }
                  showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return CustomDialog(
                            content: 'Tạo câu hỏi thành công',
                            onSubmit: () {
                              if (Navigator.canPop(dialogContext)) {
                                Navigator.pop(dialogContext);
                              }
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            });
                      });
                } else if (state is ErrorState) {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                            content: 'Đã có lỗi xảy ra',
                            onSubmit: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            });
                      });
                }
              },
              child: Container(),
            ),
            CommonWidget.addButton(
                title: 'File câu hỏi',
                onTap: () {
                  _currentUploadType = UploadType.questionImage;
                  showPickImageOptions();
                }),
            const SizedBox(
              height: 10,
            ),
            if (_questionImageUrl != null) ...[
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: CustomTextLabel(
                        'Ảnh đã được tải lên',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
            CustomTextInput(
              key: _keyAnswer,
              isRequired: true,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: "Đáp án đúng",
              isDropdownTF: true,
              dropdownItems: Constants.answer,
              onDropdownChanged: (value) {
                selectedAnswer = value!.value;
              },
              validator: (String value) {
                if (value.isEmpty) {
                  return "Vui lòng chọn đáp án";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            BaseButton(
              margin: EdgeInsets.only(top: 20),
              title: 'Tạo câu hỏi',
              borderRadius: 20,
              onTap: _createQuestion,
            ),
          ],
        ),
      );
    });
  }
}
